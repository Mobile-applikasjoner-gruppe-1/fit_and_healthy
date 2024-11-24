import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/settings/metrics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metrics_controller.g.dart';

final metricsServiceProvider = Provider<MetricsService>((ref) {
  return MetricsService();
});

@riverpod
class MetricsController extends _$MetricsController {
  late final MetricsService _metricsService;

  @override
  Future<Map<String, dynamic>> build() async {
    _metricsService = ref.read(metricsServiceProvider);

    return {
      'weightHistory': await _metricsService.getWeightHistory(),
      'height': await _metricsService.getHeight(),
      'gender':
          await _metricsService.getGender() ?? Gender.male, // Default gender
      'birthday': await _metricsService.getBirthday(),
      'weeklyWorkoutGoal': await _metricsService.getWeeklyWorkoutGoal(),
      'weightGoal': await _metricsService.getWeightGoal(),
      'intensityLevel': await _metricsService.getActivityLevel(),
    };
  }

  Future<void> addWeightEntry(double weight, DateTime date) async {
    final entry = WeightEntry(timestamp: date, weight: weight);
    await _metricsService.addWeightEntry(entry);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'weightHistory': [...currentState['weightHistory'], entry]
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
      });
    }
  }

  // Handle the weight
  Future<void> addWeight(double weight) async {
    final entry = WeightEntry(timestamp: DateTime.now(), weight: weight);
    await _metricsService.addWeightEntry(entry);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'weightHistory': [...currentState['weightHistory'], entry]
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
      });
    }
  }

  Future<double?> getLatestWeight() async {
    return _metricsService.getLatestWeight();
  }

  //Handle the height
  Future<double> getHeight() async {
    return _metricsService.getHeight();
  }

  Future<void> updateHeight(double height) async {
    await _metricsService.updateHeight(height);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'height': height,
      });
    }
  }

// Handle the Gender
  Future<Gender?> getGender() async {
    return _metricsService.getGender();
  }

  Future<void> updateGender(Gender gender) async {
    await _metricsService.updateGender(gender);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'gender': gender,
      });
    }
  }

  // Handle the birthday
  Future<DateTime?> getBirthday() async {
    return _metricsService.getBirthday();
  }

  Future<void> setBirthday(DateTime birthday) async {
    await _metricsService.setBirthday(birthday);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'birthday': birthday,
      });
    }
  }

  // Handle the weekly workouts
  Future<void> updateWeeklyWorkoutGoal(int goal) async {
    await _metricsService.updateWeeklyWorkoutGoal(goal);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'weeklyWorkoutGoal': goal,
      });
    }
  }

  // Handle the weight goal
  Future<void> updateWeightGoal(WeightGoal? goal) async {
    await _metricsService.updateWeightGoal(goal);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'weightGoal': goal,
      });
    }
  }

  Future<WeightGoal?> getWeightGoal() async {
    return _metricsService.getWeightGoal();
  }

  // Handle the activity level
  Future<void> updateActivityLevel(ActivityLevel? level) async {
    await _metricsService.updateActivityLevel(level);

    final currentState = state.asData?.value;
    if (currentState != null) {
      state = AsyncValue.data({
        ...currentState,
        'activityLevel': level,
      });
    }
  }

  Future<ActivityLevel?> getActivityLevel() async {
    return _metricsService.getActivityLevel();
  }
}
