import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/app_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';

final exerciseConverter = (
  fromFirestore: (snapshot, _) => Exercise.fromFirebase(snapshot.data()!),
  toFirestore: (Exercise exercise, _) => exercise.toFirebase(),
);

/// Repository for handling exercise data.
/// This class is responsible for all CRUD operations on exercises.
/// The repository is scoped to a specific workout.
class ExerciseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;
  final String _workoutId;

  ExerciseRepository(this._authRepository, this._workoutId);

  /// Returns a list of all exercises for the given workout.
  Future<List<Exercise>> getAllExercises() async {
    final AppUser user = _authRepository.currentUser!;

    QuerySnapshot<Exercise> querySnapshot = await _firestore
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('workouts')
        .doc(_workoutId)
        .collection('exercises')
        .withConverter(
          fromFirestore: exerciseConverter.fromFirestore,
          toFirestore: exerciseConverter.toFirestore,
        )
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Deletes all exercises for the given workout.
  Future<void> deleteAllExercises() async {
    final AppUser user = _authRepository.currentUser!;

    await _firestore
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('workouts')
        .doc(_workoutId)
        .collection('exercises')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        // TODO: Delete subcollections (sets?)
        doc.reference.delete();
      }
    });
  }

  // TODO: Add CRUD operations add, update, delete exercises
}
