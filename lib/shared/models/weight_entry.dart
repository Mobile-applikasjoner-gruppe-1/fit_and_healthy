import 'package:cloud_firestore/cloud_firestore.dart';

enum WeightEntryField {
  timestamp,
  weight,
}

extension WeightEntryFieldExtension on WeightEntryField {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class WeightEntry {
  final String id;
  final DateTime timestamp;
  final double weight;

  WeightEntry({
    required this.id,
    required this.timestamp,
    required this.weight,
  });

  factory WeightEntry.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception(
          'Document data is null for WeightEntry with ID: ${doc.id}');
    }
    return WeightEntry(
      id: doc.id,
      timestamp: (data[WeightEntryField.timestamp.toShortString()] as Timestamp)
          .toDate(),
      weight: (data[WeightEntryField.weight.toShortString()] as num).toDouble(),
    );
  }
}

class NewWeightEntry {
  final DateTime timestamp;
  final double weight;

  static bool isValidWeight(double? weight) {
    return weight != null && weight > 0 && weight <= 500;
  }

  static bool isValidTimestamp(DateTime? timestamp) {
    return timestamp != null && timestamp.isBefore(DateTime.now());
  }

  static bool isValidNewWeightEntry(NewWeightEntry entry) {
    return isValidWeight(entry.weight) && isValidTimestamp(entry.timestamp);
  }

  NewWeightEntry({
    required this.timestamp,
    required this.weight,
  });

  Map<String, dynamic> toFirestore() {
    return {
      WeightEntryField.timestamp.toShortString(): Timestamp.fromDate(timestamp),
      WeightEntryField.weight.toShortString(): weight,
    };
  }
}