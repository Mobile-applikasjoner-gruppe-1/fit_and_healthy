import 'dart:async';

import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/exercise_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_list_controller.g.dart';

@Riverpod(keepAlive: true)
class WorkoutNotifier extends _$WorkoutNotifier {
  late final FirebaseAuthRepository _authRepository;
  late final WorkoutRepository _workoutRepository;

  Map<DateTime, StreamSubscription<List<Workout>>>
      _dateWorkoutsStreamSubscriptions = {};
  Map<String, StreamSubscription<List<Exercise>>>
      _workoutExercisesStreamSubscriptions = {};

  @override
  Future<WorkoutListState> build() async {
    _authRepository = ref.read(firebaseAuthRepositoryProvider);
    _workoutRepository = WorkoutRepository(_authRepository);

    return WorkoutListState(
      cachedDateWorkouts: {},
      cachedWorkouts: {},
      cachedWorkoutExercises: {},
    );
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

  _workoutsStreamCallback(List<Workout> workouts, DateTime normalizedDate) {
    state.when(
      data: (data) {
        // Update cached workouts by adding them to a map indexed by workout id
        final updatedCachedWorkouts = {
          ...data.cachedWorkouts,
          for (final workout in workouts) workout.id: workout,
        };
        final updatedWorkoutExercises = {
          ...data.cachedWorkoutExercises,
        };

        for (final workout in workouts) {
          if (!data.cachedWorkoutExercises.containsKey(workout.id)) {
            final normalizedWorkoutDate = _dateTimeToDate(workout.dateTime);

            final exerciseRepository =
                ExerciseRepository(_authRepository, workout.id);
            final exerciseStream = exerciseRepository.getExercisesStream();
            final exerciseSubscription = exerciseStream.listen((exercises) {
              _exercisesStreamCallback(
                  exercises, normalizedWorkoutDate, workout.id);
            });

            // Track the subscription for cleanup
            _workoutExercisesStreamSubscriptions[workout.id] =
                exerciseSubscription;
          }
        }

        // Get the stale workout ids by checking the ids of the workouts in the previous cachedDateWorkouts for the current date
        final previousWorkoutIds =
            data.cachedDateWorkouts[normalizedDate]?.map((w) => w.id).toSet() ??
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
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  void listenToDate(DateTime date) {
    final normalizedDate = _dateTimeToDate(date);
    state.when(
        data: (data) {
          if (!data.cachedDateWorkouts.containsKey(normalizedDate)) {
            final stream =
                _workoutRepository.getWorkoutsStreamForDate(normalizedDate);

            // Listen to workout stream
            final subscription = stream.listen((workouts) {
              _workoutsStreamCallback(workouts, normalizedDate);
            });

            // Track date-based subscriptions for cleanup
            _dateWorkoutsStreamSubscriptions[normalizedDate] = subscription;
          }
        },
        loading: () {},
        error: (err, stack) {});
  }
}

class WorkoutListState {
  final Map<DateTime, List<Workout>> cachedDateWorkouts;
  final Map<String, Workout> cachedWorkouts;
  final Map<String, List<Exercise>> cachedWorkoutExercises;

  WorkoutListState({
    required this.cachedDateWorkouts,
    required this.cachedWorkouts,
    required this.cachedWorkoutExercises,
  });

  WorkoutListState copyWith({
    Map<DateTime, List<Workout>>? cachedDateWorkouts,
    Map<String, Workout>? cachedWorkouts,
    Map<String, List<Exercise>>? cachedWorkoutExercises,
  }) {
    return WorkoutListState(
      cachedWorkouts: cachedWorkouts ?? this.cachedWorkouts,
      cachedDateWorkouts: cachedDateWorkouts ?? this.cachedDateWorkouts,
      cachedWorkoutExercises:
          cachedWorkoutExercises ?? this.cachedWorkoutExercises,
    );
  }
}
