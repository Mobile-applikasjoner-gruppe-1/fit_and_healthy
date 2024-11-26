class WeightEntry {
  final String? id; // Optional, will be set after Firestore creation
  final DateTime timestamp;
  final double weight;

  WeightEntry({this.id, required this.timestamp, required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'weight': weight,
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map, {String? id}) {
    return WeightEntry(
      id: id,
      timestamp: DateTime.parse(map['timestamp']),
      weight: map['weight'],
    );
  }
}
