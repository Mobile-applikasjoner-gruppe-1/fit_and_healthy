import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/exercise_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_controller.g.dart';

@riverpod
class ExerciseController extends _$ExerciseController {
  ExerciseController();

  @override
  Future<void> build() async {}

  Future<void> addExercisesToWorkout(
      String workoutId, List<Exercise> exercises) async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    final exerciseRepository = ExerciseRepository(authRepository, workoutId);

    await exerciseRepository.addExercises(exercises);
  }
}
