import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/auth_user_model.dart';
import 'package:fit_and_healthy/src/features/user/user_model.dart';

final userConverter = (
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    if (!snapshot.exists) {
      throw Exception(
          'Firestore document does not exist for user ID: ${snapshot.id}');
    }
    return User.fromFirestore(snapshot.data()!, snapshot.id);
  },
  toFirestore: (User userModel, _) => userModel.toFirestore(),
);

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthRepository _authRepository;

  static String collectionName = 'users';

  late DocumentReference<User> _userRef;

  UserRepository(this._authRepository) {
    _userRef = _getUserRef();
  }

  DocumentReference<User> _getUserRef() {
    final AuthUser user = _authRepository.currentUser!;

    return _firestore
        .collection(collectionName)
        .doc(user.firebaseUser.uid)
        .withConverter<User>(
            fromFirestore: userConverter.fromFirestore,
            toFirestore: userConverter.toFirestore);
  }

  Future<void> updateUser(User user) async {
    if (!User.isValidUserModel(user)) {
      throw Exception('Invalid UserModel');
    }
    await _userRef.set(user);
  }

  Future<User?> getUser() async {
    final userDoc = await _userRef.get();
    if (userDoc.exists) {
      final userModel = userDoc.data();
      if (userModel == null || !User.isValidUserModel(userModel)) {
        throw Exception("Invalid UserModel retrieved from Firestore");
      }
      return userModel;
    }
    return null;
  }

  Future<void> createUser(User user) async {
    if (!User.isValidUserModel(user)) {
      throw Exception("Invalid UserModel provided. Validation failed.");
    }

    final userDoc = await _userRef.get();

    if (userDoc.exists) {
      throw Exception('User already exists');
    }

    await _userRef.set(user);
  }

  Future<void> updateActivityLevel(ActivityLevel activityLevel) async {
    if (!User.isValidActivityLevel(activityLevel)) {
      throw Exception('Invalid Activity Level');
    }

    await _userRef.update({
      UserField.activityLevel.toString():
          ActivityLevelExtension.toFirestore(activityLevel)
    });
  }

  Future<void> updateHeight(double height) async {
    if (!User.isValidHeight(height)) {
      throw Exception('Invalid height');
    }

    await _userRef.update({UserField.height.toString(): height});
  }

  Future<void> updateGender(Gender gender) async {
    if (!User.isValidGender(gender)) {
      throw Exception('Invalid gender');
    }

    await _userRef.update(
        {UserField.gender.toString(): GenderExtension.toFirestore(gender)});
  }

  Future<void> updateBirthday(DateTime birthday) {
    if (!User.isValidBirthday(birthday)) {
      throw Exception('Invalid birthday');
    }

    final timestamp = Timestamp.fromDate(birthday);

    return _userRef.update({UserField.birthday.toString(): timestamp});
  }

  Future<void> updateWeeklyWorkoutGoal(int goal) {
    if (!User.isValidWeeklyWorkoutGoal(goal)) {
      throw Exception('Invalid weekly workout goal');
    }

    return _userRef.update({
      UserField.weeklyWorkoutGoal.toString(): goal,
    });
  }

  Future<void> updateWeightGoal(WeightGoal goal) {
    if (!User.isValidWeightGoal(goal)) {
      throw Exception('Invalid weight goal');
    }

    return _userRef.update({
      UserField.weightGoal.toString(): WeightGoalExtension.toFirestore(goal)
    });
  }
}
