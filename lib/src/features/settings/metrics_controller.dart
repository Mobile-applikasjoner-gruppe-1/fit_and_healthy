import 'package:fit_and_healthy/src/features/settings/metrics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metrics_controller.g.dart';

enum Gender { male, female }

enum WeightGoal { gain, maintain, lose }

enum IntensityLevel { low, medium, high }

// Singleton for MetricsService
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
      'gender': Gender.male,
      'weightGoal': WeightGoal.maintain,
      'intensityLevel': IntensityLevel.medium,
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
}
