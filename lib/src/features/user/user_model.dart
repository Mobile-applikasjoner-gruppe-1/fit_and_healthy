import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';

class UserModel {
  final String id;
  final double height;
  final Gender gender;
  final DateTime? birthday;
  final int weeklyWorkoutGoal;
  final WeightGoal weightGoal;
  final ActivityLevel activityLevel;

  UserModel({
    required this.id,
    required this.height,
    required this.gender,
    this.birthday,
    required this.weeklyWorkoutGoal,
    required this.weightGoal,
    required this.activityLevel,
  });

  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      height: (data['height'] ?? 170).toDouble(),
      gender: Gender.values.firstWhere(
        (g) => g.toString() == 'Gender.${data['gender'] ?? 'male'}',
        orElse: () => Gender.male,
      ),
      birthday:
          data['birthday'] != null ? DateTime.tryParse(data['birthday']) : null,
      weeklyWorkoutGoal: data['weeklyWorkoutGoal'] ?? 3,
      weightGoal: WeightGoal.values.firstWhere(
        (w) => w.toString() == 'WeightGoal.${data['weightGoal'] ?? 'maintain'}',
        orElse: () => WeightGoal.maintain,
      ),
      activityLevel: ActivityLevel.values.firstWhere(
        (a) =>
            a.toString() ==
            'ActivityLevel.${data['activityLevel'] ?? 'moderatelyActive'}',
        orElse: () => ActivityLevel.moderatelyActive,
      ),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'height': height,
      'gender': gender.toString().split('.').last,
      'birthday': birthday?.toIso8601String(),
      'weeklyWorkoutGoal': weeklyWorkoutGoal,
      'weightGoal': weightGoal.toString().split('.').last,
      'activityLevel': activityLevel.toString().split('.').last,
    };
  }

  UserModel copyWith({
    double? height,
    Gender? gender,
    DateTime? birthday,
    int? weeklyWorkoutGoal,
    WeightGoal? weightGoal,
    ActivityLevel? activityLevel,
  }) {
    return UserModel(
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
