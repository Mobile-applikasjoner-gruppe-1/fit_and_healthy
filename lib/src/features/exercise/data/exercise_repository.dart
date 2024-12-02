import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/workout_repository.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';

final exerciseConverter = (
  fromFirestore: (snapshot, _) => Exercise.fromFirebase(snapshot),
  toFirestore: (Exercise exercise, _) => exercise.toFirestore(),
);

/// Repository for handling exercise data.
/// This class is responsible for all CRUD operations on exercises.
/// The repository is scoped to a specific workout.
class ExerciseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;
  final String _workoutId;

  static String collectionName = 'exercises';

  ExerciseRepository(this._authRepository, this._workoutId);

  CollectionReference<Exercise> _getExerciseCollection() {
    final AuthUser user = _authRepository.currentUser!;

    return _firestore
        .collection(UserRepository.collectionName)
        .doc(user.firebaseUser.uid)
        .collection(WorkoutRepository.collectionName)
        .doc(_workoutId)
        .collection(collectionName)
        .withConverter<Exercise>(
          fromFirestore: exerciseConverter.fromFirestore,
          toFirestore: exerciseConverter.toFirestore,
        );
  }

  /// Returns a list of all exercises for the given workout.
  Future<List<Exercise>> getAllExercises() async {
    QuerySnapshot<Exercise> querySnapshot =
        await _getExerciseCollection().get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Adds a new exercise to the database.
  /// Auto generates an ID for the exercise and returns it.
  /// Will throw an error if the exercise is not added successfully.
  Future<String> addExercise(Exercise exercise) async {
    DocumentReference exerciseRef =
        await _getExerciseCollection().add(exercise);

    return exerciseRef.id;
  }

  Future<void> addExercises(List<Exercise> exercises) async {
    WriteBatch batch = _firestore.batch();

    exercises.forEach((exercise) {
      final exerciseRef = _getExerciseCollection().doc();
      batch.set(exerciseRef, exercise);
    });

    await batch.commit();
  }

  /// Updates an existing exercise in the database.
  /// Overwrites the existing exercise with the new exercise data.
  /// Will throw an error if the exercise is not updated successfully.
  Future<void> updateExercise(Exercise exercise) async {
    await _getExerciseCollection().doc(exercise.id).set(exercise);
  }

  /// Deletes all exercises for the given workout.
  Future<void> deleteAllExercises() async {
    await _getExerciseCollection().get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream<List<Exercise>> getExercisesStream() {
    return _getExerciseCollection().snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }
}
