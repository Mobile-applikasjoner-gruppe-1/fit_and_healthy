import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';

class MetricsService {
  final List<WeightEntry> _weightHistory = [];
  double _height = 170.0;
  Gender? _gender;
  DateTime? _birthday;
  int _weeklyWorkoutGoal = 3;
  WeightGoal? _weightGoal = WeightGoal.maintain;
  ActivityLevel? _activityLevel;

  // Weight History
  Future<List<WeightEntry>> getWeightHistory() async {
    return List<WeightEntry>.from(_weightHistory);
  }

  Future<void> addWeightEntry(WeightEntry entry) async {
    _weightHistory.add(entry);
    _weightHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<double?> getLatestWeight() async {
    if (_weightHistory.isEmpty) return null;
    return _weightHistory.last.weight;
  }

  // Height
  Future<double> getHeight() async {
    return _height;
  }

  Future<void> updateHeight(double height) async {
    _height = height;
  }

  // Gender
  Future<Gender?> getGender() async {
    return _gender;
  }

  Future<void> updateGender(Gender gender) async {
    _gender = gender;
  }

  // Birthday
  Future<DateTime?> getBirthday() async {
    return _birthday;
  }

  Future<void> setBirthday(DateTime birthday) async {
    _birthday = birthday;
  }

  // Weekly Workout Goals
  Future<int> getWeeklyWorkoutGoal() async {
    return _weeklyWorkoutGoal;
  }

  Future<void> updateWeeklyWorkoutGoal(int goal) async {
    _weeklyWorkoutGoal = goal;
  }

  // Weight Goals
  Future<WeightGoal?> getWeightGoal() async {
    return _weightGoal;
  }

  Future<void> updateWeightGoal(WeightGoal? goal) async {
    _weightGoal = goal;
  }

  // Activity Level
  Future<ActivityLevel?> getActivityLevel() async {
    return _activityLevel;
  }

  Future<void> updateActivityLevel(ActivityLevel? level) async {
    _activityLevel = level;
  }
}
