import 'package:uuid/uuid.dart';

import 'fooditem.dart'; // For unique ID generation

class Meal {
  final String id; // Unique identifier for the meal
  final String name; // Name of the meal
  final List<_MealItem> _items = []; // Food items in the meal

  Meal({required this.name})
      : id = Uuid().v4(); // Generate a unique ID using the uuid package

  // Method to add a FoodItem with a specified weight in grams
  void addFoodItem(FoodItem foodItem, double grams) {
    _items.add(_MealItem(foodItem, grams));
  }

  // Getter to access _items outside the class
  List<_MealItem> get items => _items;

  // Method to update the grams of an existing FoodItem
  void updateFoodItemGrams(FoodItem foodItem, double newGrams) {
    for (var item in _items) {
      if (item.foodItem == foodItem) {
        item.grams = newGrams; // Update the grams value
        break; // Exit loop once the item is found and updated
      }
    }
  }

  // Method to remove a FoodItem based on its barcode or name
  void removeFoodItem({String? barcode, String? name}) {
    _items.removeWhere((item) {
      if (barcode != null) {
        return item.foodItem.barcode == barcode; // Remove by barcode
      } else if (name != null) {
        return item.foodItem.name == name; // Remove by name
      }
      return false; // No match found
    });
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

    for (var item in _items) {
      final nutritionInfo = item.foodItem.nutritionInfo;
      final multiplier = item.grams / 100;

      totals['calories'] =
          totals['calories']! + (nutritionInfo['calories']! * multiplier);
      totals['protein'] =
          totals['protein']! + (nutritionInfo['protein']! * multiplier);
      totals['fat'] = totals['fat']! + (nutritionInfo['fat']! * multiplier);
      totals['sugars'] =
          totals['sugars']! + (nutritionInfo['sugars']! * multiplier);
      totals['fiber'] =
          totals['fiber']! + (nutritionInfo['fiber']! * multiplier);
      totals['carbs'] =
          totals['carbs']! + (nutritionInfo['carbs']! * multiplier);
    }

    return totals;
  }

  // Method to convert Meal object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': _items.map((item) => item.toJson()).toList(),
    };
  }

  // Factory constructor to create Meal from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    final meal = Meal(name: json['name']);
    for (var item in json['items']) {
      final foodItem = FoodItem.fromJson(item['foodItem']);
      final grams = item['grams'];
      meal.addFoodItem(foodItem, grams);
    }
    return meal;
  }
}

// Helper class to store each FoodItem and its weight in the meal
class _MealItem {
  final FoodItem foodItem;
  double grams;

  _MealItem(this.foodItem, this.grams);

  // Method to convert _MealItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(), // FoodItem has a toJson method
      'grams': grams,
    };
  }
}
