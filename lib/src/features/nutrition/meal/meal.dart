import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';

class Meal {
  final String id; // Unique identifier for the meal
  final String name; // Name of the meal
  final DateTime timestamp; // Time for the meal
  List<FoodItem> items = []; // Food items in the meal

  Meal({required this.name, required this.timestamp, required this.id});

  // Method to remove a FoodItem based on its barcode or name
  void removeFoodItem({String? barcode, String? name}) {
    items.removeWhere((item) {
      if (barcode != null) {
        return item.barcode == barcode; // Remove by barcode
      } else if (name != null) {
        return item.name == name; // Remove by name
      }
      return false; // No match found
    });
  }

  void removeFoodItemByIndex(int index) {
    items.removeAt(index);
  }

  // Method to calculate total nutrition values for the meal
  Map<String, double> calculateTotalNutrition() {
    final totals = {
      'calories': 0.0,
      'protein': 0.0,
      'fat': 0.0,
      'sugars': 0.0,
      'fiber': 0.0,
      'carbs': 0.0,
    };

    for (var item in items) {
      final itemNutrion = item.calculateNutrition();

      totals['calories'] = totals['calories']! + (itemNutrion['calories']!);
      totals['protein'] = totals['protein']! + (itemNutrion['protein']!);
      totals['fat'] = totals['fat']! + (itemNutrion['fat']!);
      totals['sugars'] = totals['sugars']! + (itemNutrion['sugars']!);
      totals['fiber'] = totals['fiber']! + (itemNutrion['fiber']!);
      totals['carbs'] = totals['carbs']! + (itemNutrion['carbs']!);
    }

    return totals;
  }

  // Method to convert Meal object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Factory constructor to create Meal from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    final meal = Meal(
        name: json['name'],
        timestamp: DateTime.parse(json['timestamp']),
        id: json['id']);
    for (var item in json['items']) {
      final foodItem = FoodItem.fromFoodFactsJson(item['foodItem']);
      meal.items.add(foodItem);
    }
    return meal;
  }

  Map<String, dynamic> toFirebase() {
    return {
      'name': name,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Meal.fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Document data is null for document ID: ${snapshot.id}');
    }

    final name = data['name'];
    final timestamp = data['timestamp'];

    if (name is! String) {
      throw Exception('Name is not a string');
    }

    if (timestamp is! Timestamp) {
      throw Exception('Timestamp is not a Timestamp');
    }

    return Meal(
      name: name,
      timestamp: timestamp.toDate(),
      id: snapshot.id,
    );
  }
}
