import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/workout_repository.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';

final exerciseConverter = (
  fromFirestore: (snapshot, _) => Exercise.fromFirebase(snapshot.data()!),
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
    final AuthUser user = _authRepository.currentUser!;

    CollectionReference exercisesRef = _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('workouts')
        .doc(_workoutId)
        .collection('exercises');

    DocumentReference exerciseRef = await exercisesRef
        .withConverter<Exercise>(
          fromFirestore: exerciseConverter.fromFirestore,
          toFirestore: exerciseConverter.toFirestore,
        )
        .add(exercise);

    return exerciseRef.id;
  }

  /// Updates an existing exercise in the database.
  /// Overwrites the existing exercise with the new exercise data.
  /// Will throw an error if the exercise is not updated successfully.
  Future<void> updateExercise(Exercise exercise) async {
    final AuthUser user = _authRepository.currentUser!;

    DocumentReference exerciseRef = _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
        .collection('workouts')
        .doc(_workoutId)
        .collection('exercises')
        .doc(exercise.id);

    await exerciseRef
        .withConverter<Exercise>(
          fromFirestore: exerciseConverter.fromFirestore,
          toFirestore: exerciseConverter.toFirestore,
        )
        .set(exercise);
  }

  /// Deletes all exercises for the given workout.
  Future<void> deleteAllExercises() async {
    final AuthUser user = _authRepository.currentUser!;

    await _firestore
        .collection('users')
        .doc(user.firebaseUser.uid)
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
