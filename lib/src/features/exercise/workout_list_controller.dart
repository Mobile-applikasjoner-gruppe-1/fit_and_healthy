import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_list_controller.g.dart';

@Riverpod(keepAlive: true)
class WorkoutNotifier extends _$WorkoutNotifier {
  late final WorkoutRepository _workoutRepository;

  @override
  Future<WorkoutListState> build() async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    _workoutRepository = WorkoutRepository(authRepository);

    return WorkoutListState(
      workoutDateStreams: {},
      cachedWorkouts: {},
    );
  }

  DateTime _dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  void _listenToDate(DateTime date) {
    state.when(
      data: (data) {
        if (!data.workoutDateStreams.containsKey(date)) {
          final stream = _workoutRepository.getWorkoutsStreamForDate(date);
          state = AsyncValue.data(data.copyWith());

          stream.listen((workouts) {
            state = AsyncValue.data(data.copyWith(
              workoutDateStreams: {
                ...data.workoutDateStreams,
                date: stream,
              },
              cachedWorkouts: {
                ...data.cachedWorkouts,
                for (final workout in workouts) workout.id: workout,
              },
            ));
          });
        }
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  void changeDate(DateTime newDate) {
    final normalizedDate = _dateTimeToDate(newDate);
    _listenToDate(normalizedDate);
  }

  Stream<List<Workout>> getWorkoutDateStreams(DateTime date) {
    return state.maybeWhen(
      data: (data) => data.workoutDateStreams[date] ?? Stream.empty(),
      orElse: () => Stream.empty(),
    );
  }
}

class WorkoutListState {
  final Map<DateTime, Stream<List<Workout>>> workoutDateStreams;
  final Map<String, Workout> cachedWorkouts;

  WorkoutListState({
    required this.workoutDateStreams,
    required this.cachedWorkouts,
  });

  WorkoutListState copyWith({
    Map<DateTime, Stream<List<Workout>>>? workoutDateStreams,
    Map<String, Workout>? cachedWorkouts,
  }) {
    return WorkoutListState(
      workoutDateStreams: workoutDateStreams ?? this.workoutDateStreams,
      cachedWorkouts: cachedWorkouts ?? this.cachedWorkouts,
    );
  }
}
