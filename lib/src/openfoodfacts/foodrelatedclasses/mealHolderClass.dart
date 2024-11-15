import 'package:uuid/uuid.dart';

import 'mealClass.dart'; // Import for unique ID generation

/// remember change the date part

/// Holds the meals

class MealHolder {
  final String id; // Unique identifier for the MealHolder
  final DateTime date; // Date associated with the meals
  final List<Meal> meals; // List of meals

  MealHolder({required this.date})
      : id = Uuid().v4(), // Generate a unique ID using the uuid package
        meals = []; // Initialize the meals list

  // Method to add a Meal to the MealHolder
  void addMeal(Meal meal) {
    meals.add(meal);
  }

  // Create a global variable to store the MealHolder
  //MealHolder globalMealHolder = MealHolder(date: DateTime.now());

  // Getter to access meals outside the class
  List<Meal> get items => meals;

  // Method to remove a Meal from the MealHolder by its ID
  void removeMeal(String mealId) {
    meals.removeWhere((meal) => meal.id == mealId);
  }

  // Method to calculate total nutrition values for all meals in the MealHolder
  Map<String, double> calculateTotalNutrition() {
    final totals = {
      'calories': 0.0,
      'protein': 0.0,
      'fat': 0.0,
      'sugars': 0.0,
      'fiber': 0.0,
      'carbs': 0.0,
    };

    for (var meal in meals) {
      final mealNutrition = meal.calculateTotalNutrition();
      totals['calories'] = totals['calories']! + mealNutrition['calories']!;
      totals['protein'] = totals['protein']! + mealNutrition['protein']!;
      totals['fat'] = totals['fat']! + mealNutrition['fat']!;
      totals['sugars'] = totals['sugars']! + mealNutrition['sugars']!;
      totals['fiber'] = totals['fiber']! + mealNutrition['fiber']!;
      totals['carbs'] = totals['carbs']! + mealNutrition['carbs']!;
    }

    return totals;
  }

  // Method to convert MealHolder object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(), // Convert date to ISO 8601 string
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }

  // Factory constructor to create MealHolder from JSON
  factory MealHolder.fromJson(Map<String, dynamic> json) {
    final mealHolder = MealHolder(
      date: DateTime.parse(json['date']), // Parse date from string
    );

    for (var mealJson in json['meals']) {
      final meal = Meal.fromJson(mealJson);
      mealHolder.addMeal(meal);
    }
    return mealHolder;
  }
}
