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
      cachedDateWorkouts: {},
      cachedWorkouts: {},
    );
  }

  DateTime _dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  void listenToDate(DateTime date) {
    final normalizedDate = _dateTimeToDate(date);
    state.when(
      data: (data) {
        if (!data.cachedDateWorkouts.containsKey(normalizedDate)) {
          final stream =
              _workoutRepository.getWorkoutsStreamForDate(normalizedDate);
          // state = AsyncValue.data(data.copyWith());

          stream.listen((workouts) {
            state = AsyncValue.data(data.copyWith(cachedDateWorkouts: {
              ...data.cachedDateWorkouts,
              normalizedDate: workouts,
            }, cachedWorkouts: {
              ...data.cachedWorkouts,
              for (final workout in workouts) workout.id: workout,
            }));
          });
        }
      },
      loading: () {},
      error: (err, stack) {},
    );
  }
}

class WorkoutListState {
  final Map<DateTime, List<Workout>> cachedDateWorkouts;
  final Map<String, Workout> cachedWorkouts;

  WorkoutListState({
    required this.cachedDateWorkouts,
    required this.cachedWorkouts,
  });

  WorkoutListState copyWith({
    Map<DateTime, List<Workout>>? cachedDateWorkouts,
    Map<String, Workout>? cachedWorkouts,
  }) {
    return WorkoutListState(
      cachedWorkouts: cachedWorkouts ?? this.cachedWorkouts,
      cachedDateWorkouts: cachedDateWorkouts ?? this.cachedDateWorkouts,
    );
  }
}
