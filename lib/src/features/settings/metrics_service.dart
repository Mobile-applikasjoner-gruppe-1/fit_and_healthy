import 'package:fit_and_healthy/shared/models/WeightEntry.dart';

class MetricsService {
  final List<WeightEntry> _weightHistory = [];
  double _height = 170.0;

  Future<List<WeightEntry>> getWeightHistory() async {
    return List<WeightEntry>.from(_weightHistory);
  }

  Future<void> addWeightEntry(WeightEntry entry) async {
    _weightHistory.add(entry);
    _weightHistory.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<double> getHeight() async {
    return _height;
  }

  Future<void> updateHeight(double height) async {
    _height = height;
  }

  Future<double?> getLatestWeight() async {
    if (_weightHistory.isEmpty) return null;
    return _weightHistory.last.weight;
  }
}
