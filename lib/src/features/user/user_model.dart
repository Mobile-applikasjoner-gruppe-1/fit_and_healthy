import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/metrics/metric_state.dart';

enum UserField {
  height,
  gender,
  birthday,
  weeklyWorkoutGoal,
  weightGoal,
  activityLevel,
}

class User {
  final String id;
  final double height;
  final Gender gender;
  final DateTime birthday;
  final int weeklyWorkoutGoal;
  final WeightGoal weightGoal;
  final ActivityLevel activityLevel;

  User({
    required this.id,
    required this.height,
    required this.gender,
    required this.birthday,
    required this.weeklyWorkoutGoal,
    required this.weightGoal,
    required this.activityLevel,
  });

  static bool isValidHeight(double? height) {
    if (height == 0 || height! <= 20 || height > 300) return false;
    return true;
  }

  static bool isValidGender(Gender? gender) {
    return gender != null;
  }

  static bool isValidBirthday(DateTime? birthday) {
    return birthday != null &&
        birthday.isBefore(DateTime.now()) &&
        birthday.year > 1900;
  }

  static bool isValidWeeklyWorkoutGoal(int? weeklyWorkoutGoal) {
    return weeklyWorkoutGoal != null &&
        weeklyWorkoutGoal >= 0 &&
        weeklyWorkoutGoal <= 28;
  }

  static bool isValidWeightGoal(WeightGoal? weightGoal) {
    return weightGoal != null;
  }

  static bool isValidActivityLevel(activityLevel) {
    return activityLevel != null;
  }

  static bool isValidUserModel(User userModel) {
    return isValidHeight(userModel.height) &&
        isValidGender(userModel.gender) &&
        isValidBirthday(userModel.birthday) &&
        isValidWeeklyWorkoutGoal(userModel.weeklyWorkoutGoal) &&
        isValidWeightGoal(userModel.weightGoal) &&
        isValidActivityLevel(userModel.activityLevel);
  }

  factory User.fromFirestore(Map<String, dynamic> map, String id) {
    if (map.isEmpty) {
      throw Exception('Firestore data is empty for user ID: $id');
    }

    return User(
      id: id,
      height: (map[UserField.height.toString()] as num).toDouble(),
      gender: GenderExtension.fromFirestore(
          map[UserField.gender.toString()] as String),
      birthday: (map[UserField.birthday.toString()] as Timestamp).toDate(),
      weeklyWorkoutGoal: map[UserField.weeklyWorkoutGoal.toString()] as int,
      weightGoal: WeightGoalExtension.fromFirestore(
          map[UserField.weightGoal.toString()] as String),
      activityLevel: ActivityLevelExtension.fromFirestore(
          map[UserField.activityLevel.toString()] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      UserField.height.toString(): height,
      UserField.gender.toString(): gender.toString().split('.').last,
      UserField.birthday.toString(): Timestamp.fromDate(birthday),
      UserField.weeklyWorkoutGoal.toString(): weeklyWorkoutGoal,
      UserField.weightGoal.toString(): weightGoal.toString().split('.').last,
      UserField.activityLevel.toString():
          ActivityLevelExtension.toFirestore(activityLevel),
    };
  }

  User copyWith({
    double? height,
    Gender? gender,
    DateTime? birthday,
    int? weeklyWorkoutGoal,
    WeightGoal? weightGoal,
    ActivityLevel? activityLevel,
  }) {
    return User(
      id: id,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weeklyWorkoutGoal: weeklyWorkoutGoal ?? this.weeklyWorkoutGoal,
      weightGoal: weightGoal ?? this.weightGoal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}

extension UserModelToMetricsState on User {
  MetricsState toMetricsState(List<WeightEntry> weightHistory) {
    return MetricsState(
      weightHistory: weightHistory,
      height: height,
      gender: gender,
      birthday: birthday,
      weeklyWorkoutGoal: weeklyWorkoutGoal,
      weightGoal: weightGoal,
      activityLevel: activityLevel,
    );
  }
}
