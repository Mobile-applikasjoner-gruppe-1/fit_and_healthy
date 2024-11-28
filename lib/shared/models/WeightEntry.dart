class WeightEntry {
  final String? id;
  final DateTime timestamp;
  final double weight;

  WeightEntry({
    this.id,
    required this.timestamp,
    required this.weight,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'weight': weight,
    };
  }

  factory WeightEntry.fromFirestore(Map<String, dynamic> map, {String? id}) {
    return WeightEntry(
      id: id,
      timestamp: DateTime.parse(map['timestamp']),
      weight: map['weight'],
    );
  }
}
