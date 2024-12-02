import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_controller.g.dart';

@riverpod
class WorkoutController extends _$WorkoutController {
  WorkoutController();

  @override
  Future<void> build() async {}

  Future<String> addWorkout(Workout workout) async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    final workoutRepository = WorkoutRepository(authRepository);

    return await workoutRepository.addWorkout(workout);
  }
}
