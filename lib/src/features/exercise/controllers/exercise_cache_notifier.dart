import 'dart:async';

import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/exercise_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_cache_notifier.g.dart';

@Riverpod(keepAlive: true)
class ExerciseCacheNotifier extends _$ExerciseCacheNotifier {
  late final FirebaseAuthRepository _authRepository;
  late final WorkoutRepository _workoutRepository;

  Map<DateTime, StreamSubscription<List<Workout>>>
      _dateWorkoutsStreamSubscriptions = {};
  Map<DateTime, Stream<List<Workout>>> _dateWorkoutsStreams = {};
  Map<String, StreamSubscription<List<Exercise>>>
      _workoutExercisesStreamSubscriptions = {};
  Map<String, Stream<List<Exercise>>> _workoutExercisesStreams = {};
  Map<DateTime, bool> _datesWithExerciseListeners = {};

  @override
  Future<ExerciseCacheState> build() async {
    _authRepository = ref.read(firebaseAuthRepositoryProvider);
    _workoutRepository = WorkoutRepository(_authRepository);

    ref.read(firebaseAuthRepositoryProvider).userChanges().listen((user) {
      if (user == null) {
        _clearAllData();
      }
    });

    return ExerciseCacheState(
      cachedDateWorkouts: {},
      cachedWorkouts: {},
      cachedWorkoutExercises: {},
    );
  }

  void _clearAllData() {
    print('Clearing all data and subscriptions for exercise cache notifier');

    // Cancel all subscriptions
    for (var subscription in _dateWorkoutsStreamSubscriptions.values) {
      subscription.cancel();
    }
    for (var subscription in _workoutExercisesStreamSubscriptions.values) {
      subscription.cancel();
    }

    // Clear all data
    _dateWorkoutsStreamSubscriptions.clear();
    _dateWorkoutsStreams.clear();
    _workoutExercisesStreamSubscriptions.clear();
    _workoutExercisesStreams.clear();
    _datesWithExerciseListeners.clear();

    // Clear the state
    state = AsyncValue.data(ExerciseCacheState(
      cachedDateWorkouts: {},
      cachedWorkouts: {},
      cachedWorkoutExercises: {},
    ));
  }

  DateTime _dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  _exercisesStreamCallback(List<Exercise> exercises,
      DateTime normalizedWorkoutDate, String workoutId) {
    state.when(
      data: (data) {
        Workout? workout;
        final workoutsForDate =
            data.cachedDateWorkouts[normalizedWorkoutDate] ?? [];
        final List<Workout> updatedWorkoutsForDate = [];
        for (final w in workoutsForDate) {
          if (w.id == workoutId) {
            w.exercises = exercises;
            updatedWorkoutsForDate.add(w);
            workout = w;
          } else {
            updatedWorkoutsForDate.add(w);
          }
        }

        state = AsyncValue.data(data.copyWith(
          cachedWorkoutExercises: {
            ...data.cachedWorkoutExercises,
            workoutId: exercises,
          },
          cachedDateWorkouts: {
            ...data.cachedDateWorkouts,
            normalizedWorkoutDate: updatedWorkoutsForDate,
          },
          cachedWorkouts: workout != null
              ? {
                  ...data.cachedWorkouts,
                  workoutId: workout,
                }
              : null,
        ));
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  _workoutsStreamCallback(
      List<Workout> workouts, DateTime normalizedDate, bool listenToExercises) {
    state.when(
      data: (data) {
        try {
          // Update cached workouts by adding them to a map indexed by workout id
          final updatedCachedWorkouts = {
            ...data.cachedWorkouts,
            for (final workout in workouts) workout.id: workout,
          };
          final updatedWorkoutExercises = {
            ...data.cachedWorkoutExercises,
          };

          if (listenToExercises) {
            for (final workout in workouts) {
              if (!data.cachedWorkoutExercises.containsKey(workout.id)) {
                final normalizedWorkoutDate = _dateTimeToDate(workout.dateTime);

                final exerciseStream =
                    _getExerciseStreamByWorkoutId(workout.id);
                if (_workoutExercisesStreamSubscriptions[workout.id] != null) {
                  _workoutExercisesStreamSubscriptions[workout.id]?.cancel();
                }
                final exerciseSubscription = exerciseStream.listen((exercises) {
                  _exercisesStreamCallback(
                      exercises, normalizedWorkoutDate, workout.id);
                }, onError: (err, stack) {
                  print('Error listening to exercises: $err');
                });

                // Track the subscription for cleanup
                _workoutExercisesStreamSubscriptions[workout.id] =
                    exerciseSubscription;
              }
            }
          }

          // Get the stale workout ids by checking the ids of the workouts in the previous cachedDateWorkouts for the current date
          final previousWorkoutIds = data.cachedDateWorkouts[normalizedDate]
                  ?.map((w) => w.id)
                  .toSet() ??
              {};

          final currentWorkoutIds = workouts.map((w) => w.id).toSet();

          final staleWorkoutIds =
              previousWorkoutIds.difference(currentWorkoutIds);
          for (final staleId in staleWorkoutIds) {
            _workoutExercisesStreamSubscriptions[staleId]?.cancel();
            _workoutExercisesStreamSubscriptions.remove(staleId);
            updatedCachedWorkouts.remove(staleId);
            updatedWorkoutExercises.remove(staleId);
          }

          // Update state
          state = AsyncValue.data(data.copyWith(
            cachedDateWorkouts: {
              ...data.cachedDateWorkouts,
              normalizedDate: workouts,
            },
            cachedWorkouts: updatedCachedWorkouts,
            cachedWorkoutExercises: updatedWorkoutExercises,
          ));
        } catch (e) {
          print("Error updating workouts stream: $e");
        }
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  Stream<List<Exercise>> _getExerciseStreamByWorkoutId(String workoutId) {
    final existingStream = _workoutExercisesStreams[workoutId];
    if (existingStream != null) {
      return existingStream;
    }

    final exerciseRepository = ExerciseRepository(_authRepository, workoutId);
    final newStream = exerciseRepository.getExercisesStream();
    _workoutExercisesStreams[workoutId] = newStream;
    return newStream;
  }

  void listenToDate(DateTime date, bool listenToExercises) {
    final normalizedDate = _dateTimeToDate(date);
    state.when(
        data: (data) {
          try {
            if (!_dateWorkoutsStreams.containsKey(normalizedDate)) {
              try {
                final stream =
                    _workoutRepository.getWorkoutsStreamForDate(normalizedDate);

                // Listen to workout stream
                final subscription = stream.listen((workouts) {
                  _workoutsStreamCallback(
                      workouts, normalizedDate, listenToExercises);
                }, onError: (err, stack) {
                  print('Error listening to workouts: $err');
                });

                // Track date-based subscriptions for cleanup
                _dateWorkoutsStreamSubscriptions[normalizedDate] = subscription;
                _dateWorkoutsStreams[normalizedDate] = stream;
              } catch (e) {
                print("Error initializing stream: $e");
                return;
              }
            } else if (listenToExercises &&
                !_datesWithExerciseListeners.containsKey(normalizedDate)) {
              try {
                final oldSubscription =
                    _dateWorkoutsStreamSubscriptions[normalizedDate];
                final stream = _dateWorkoutsStreams[normalizedDate];

                if (stream == null) {
                  throw Exception('Stream not found for date $normalizedDate');
                }

                if (oldSubscription != null) {
                  oldSubscription.cancel();
                }

                final subscription = stream.listen((workouts) {
                  _workoutsStreamCallback(
                      workouts, normalizedDate, listenToExercises);
                }, onError: (err, stack) {
                  print('Error listening to workouts: $err');
                });

                data.cachedDateWorkouts[normalizedDate]?.forEach((workout) {
                  final exerciseStream =
                      _getExerciseStreamByWorkoutId(workout.id);
                  final exerciseSubscription =
                      exerciseStream.listen((exercises) {
                    _exercisesStreamCallback(
                        exercises, normalizedDate, workout.id);
                  }, onError: (err, stack) {
                    print('Error listening to exercises: $err');
                  });

                  _workoutExercisesStreamSubscriptions[workout.id] =
                      exerciseSubscription;
                });

                _dateWorkoutsStreamSubscriptions[normalizedDate] = subscription;
              } catch (e) {
                print("Error initializing workout stream: $e");
                return;
              }
            }
            if (listenToExercises) {
              _datesWithExerciseListeners[normalizedDate] = true;
            }
          } catch (e) {
            print("Error listening to date: $e");
          }
        },
        loading: () {},
        error: (err, stack) {});
  }
}

class ExerciseCacheState {
  final Map<DateTime, List<Workout>> cachedDateWorkouts;
  final Map<String, Workout> cachedWorkouts;
  final Map<String, List<Exercise>> cachedWorkoutExercises;

  ExerciseCacheState({
    required this.cachedDateWorkouts,
    required this.cachedWorkouts,
    required this.cachedWorkoutExercises,
  });

  ExerciseCacheState copyWith({
    Map<DateTime, List<Workout>>? cachedDateWorkouts,
    Map<String, Workout>? cachedWorkouts,
    Map<String, List<Exercise>>? cachedWorkoutExercises,
  }) {
    return ExerciseCacheState(
      cachedWorkouts: cachedWorkouts ?? this.cachedWorkouts,
      cachedDateWorkouts: cachedDateWorkouts ?? this.cachedDateWorkouts,
      cachedWorkoutExercises:
          cachedWorkoutExercises ?? this.cachedWorkoutExercises,
    );
  }
}
