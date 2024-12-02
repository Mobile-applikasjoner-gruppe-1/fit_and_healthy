import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum representing the fields of a weight entry document in Firestore.
///
/// Fields:
/// - [timestamp]: The timestamp of the weight entry.
/// - [weight]: The weight value in the entry.
enum WeightEntryField {
  timestamp,
  weight,
}

/// Extension on [WeightEntryField] to provide utility methods.
extension WeightEntryFieldExtension on WeightEntryField {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

/// Represents a weight entry fetched from Firestore.
///
/// Contains an ID, timestamp, and weight value.
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

/// Represents a new weight entry to be added to Firestore.
///
/// Contains validation methods for ensuring valid data before saving.
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
