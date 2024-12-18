import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_entry.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';

/// Represents the state of user metrics including:
/// - Weight history
/// - Height
/// - Gender
/// - Birthday
/// - Weekly workout goal
/// - Weight goal
/// - Activity level
///
/// This class is immutable, and updates are achieved using the `copyWith` method.
class MetricsState {
  final List<WeightEntry> weightHistory;
  final double height;
  final Gender gender;
  final DateTime birthday;
  final int weeklyWorkoutGoal;
  final WeightGoal weightGoal;
  final ActivityLevel activityLevel;

  MetricsState({
    required this.weightHistory,
    required this.height,
    required this.gender,
    required this.birthday,
    required this.weeklyWorkoutGoal,
    required this.weightGoal,
    required this.activityLevel,
  });

  MetricsState copyWith({
    List<WeightEntry>? weightHistory,
    double? height,
    Gender? gender,
    DateTime? birthday,
    int? weeklyWorkoutGoal,
    WeightGoal? weightGoal,
    ActivityLevel? activityLevel,
  }) {
    return MetricsState(
      weightHistory: weightHistory ?? this.weightHistory,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weeklyWorkoutGoal: weeklyWorkoutGoal ?? this.weeklyWorkoutGoal,
      weightGoal: weightGoal ?? this.weightGoal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
