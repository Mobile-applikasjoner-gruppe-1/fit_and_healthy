import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/exercise/data/exercise_repository.dart';
import 'package:fit_and_healthy/src/features/user/user_repository.dart';

final workoutConverter = (
  fromFirestore: (snapshot, _) => Workout.fromFirestore(snapshot),
  toFirestore: (Workout workout, _) => workout.toFirestore(),
);

/// Repository for handling workout data.
/// This class is responsible for all CRUD operations on workouts.
class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  static String collectionName = 'workouts';

  WorkoutRepository(this._authRepository);

  CollectionReference<Workout> _getWorkoutCollection() {
    final AuthUser user = _authRepository.currentUser!;

    return _firestore
        .collection(UserRepository.collectionName)
        .doc(user.firebaseUser.uid)
        .collection(collectionName)
        .withConverter<Workout>(
          fromFirestore: workoutConverter.fromFirestore,
          toFirestore: workoutConverter.toFirestore,
        );
  }

  /// Returns a list of all workouts for a given day.
  /// The date parameter is automatically converted to the start of the day.
  /// Will return an empty list if no workouts are found.
  /// Will throw an error if the query fails.
  Future<List<Workout>> getAllWorkoutsForDate(DateTime date) async {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot<Workout> querySnapshot = await _getWorkoutCollection()
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateTime', isLessThanOrEqualTo: endOfDay)
        .withConverter<Workout>(
            fromFirestore: workoutConverter.fromFirestore,
            toFirestore: workoutConverter.toFirestore)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Returns a stream of all workouts for a given day.
  /// The date parameter is automatically converted to the start of the day.
  Stream<List<Workout>> getWorkoutsStreamForDate(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final AuthUser? user = _authRepository.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    print('Getting workouts from database for date: $startOfDay');

    return _firestore
        .collection(UserRepository.collectionName)
        .doc(user.firebaseUser.uid)
        .collection(collectionName)
        .withConverter<Workout>(
          fromFirestore: workoutConverter.fromFirestore,
          toFirestore: workoutConverter.toFirestore,
        )
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateTime', isLessThanOrEqualTo: endOfDay)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Adds a new workout to the database.
  /// Auto generates an ID for the workout and returns it.
  /// Will throw an error if the workout is not added successfully.
  Future<String> addWorkout(Workout workout) async {
    CollectionReference workoutsRef = _getWorkoutCollection();

    DocumentReference workoutRef = await workoutsRef
        .withConverter<Workout>(
            fromFirestore: workoutConverter.fromFirestore,
            toFirestore: workoutConverter.toFirestore)
        .add(workout);

    return workoutRef.id;
  }

  /// Updates an existing workout in the database.
  /// Overwrites the existing workout with the new workout data.
  /// Will throw an error if the workout is not updated successfully.
  Future<void> updateWorkout(Workout workout) async {
    DocumentReference workoutRef = _getWorkoutCollection().doc(workout.id);

    await workoutRef
        .withConverter<Workout>(
            fromFirestore: workoutConverter.fromFirestore,
            toFirestore: workoutConverter.toFirestore)
        .set(workout);
  }

  /// Deletes an existing workout from the database.
  /// Will throw an error if the workout is not deleted successfully.
  Future<void> deleteWorkout(String workoutId) async {
    CollectionReference workoutsRef = _getWorkoutCollection();

    final ExerciseRepository _exerciseRepository =
        ExerciseRepository(_authRepository, workoutId);
    await _exerciseRepository.deleteAllExercises();

    workoutsRef.doc(workoutId).delete();
  }
}
