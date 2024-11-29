import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntry {
  final String id;
  final DateTime timestamp;
  final double weight;

  WeightEntry({
    required this.id,
    required this.timestamp,
    required this.weight,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'weight': weight,
    };
  }

  factory WeightEntry.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception(
          'Document data is null for WeightEntry with ID: ${doc.id}');
    }
    return WeightEntry(
      id: doc.id,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      weight: (data['weight'] as num).toDouble(),
    );
  }
}

class NewWeightEntry {
  final DateTime timestamp;
  final double weight;

  NewWeightEntry({
    required this.timestamp,
    required this.weight,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'weight': weight,
    };
  }
}
