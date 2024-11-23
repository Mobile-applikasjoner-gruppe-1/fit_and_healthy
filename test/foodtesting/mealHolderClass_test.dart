import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/fooditem.dart';
import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/mealClass.dart';
import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/mealHolderClass.dart';
import 'package:flutter_test/flutter_test.dart'; // Import Flutter's testing library

void main() {
  group('MealHolder Tests', () {
    test('Adding a Meal', () {
      // Arrange
      final mealHolder = MealHolder(date: DateTime.now());
      final foodItem =
          FoodItem(barcode: '12345', name: 'Test Food', nutritionInfo: {
        'calories': 100.0,
        'protein': 5.0,
        'fat': 1.0,
        'sugars': 0.5,
        'fiber': 2.0,
        'carbs': 20.0,
      });
      final meal = Meal(name: 'Breakfast');
      foodItem.setGrams(100);
      meal.addFoodItem(foodItem); // Add food item to meal

      // Act
      mealHolder.addMeal(meal);

      // Assert
      expect(mealHolder.meals.length, 1);
      expect(mealHolder.meals[0].name, 'Breakfast');
    });

    test('Removing a Meal', () {
      // Arrange
      final mealHolder = MealHolder(date: DateTime.now());
      final meal1 = Meal(name: 'Breakfast');
      final meal2 = Meal(name: 'Lunch');
      mealHolder.addMeal(meal1);
      mealHolder.addMeal(meal2);

      // Act
      mealHolder.removeMeal(meal1.id); // Remove the first meal

      // Assert
      expect(mealHolder.meals.length, 1);
      expect(mealHolder.meals[0].name, 'Lunch');
    });

    /// Testing calculation of total nutritions in meal
    test('Calculating Total Nutrition', () {
      // Arrange
      final mealHolder = MealHolder(date: DateTime.now());
      final foodItem1 =
          FoodItem(barcode: '12345', name: 'Test Food 1', nutritionInfo: {
        'calories': 100.0,
        'protein': 5.0,
        'fat': 1.0,
        'sugars': 0.5,
        'fiber': 2.0,
        'carbs': 20.0,
      });
      final foodItem2 =
          FoodItem(barcode: '67890', name: 'Test Food 2', nutritionInfo: {
        'calories': 200.0,
        'protein': 10.0,
        'fat': 2.0,
        'sugars': 1.0,
        'fiber': 3.0,
        'carbs': 40.0,
      });
      final foodItem3 =
          FoodItem(barcode: '6789052', name: 'Test Food 3', nutritionInfo: {
        'calories': 100.0,
        'protein': 10.0,
        'fat': 2.0,
        'sugars': 1.0,
        'fiber': 9.0,
        'carbs': 40.0,
      });
      final meal1 = Meal(name: 'Breakfast');
      foodItem1.setGrams(100);
      meal1.addFoodItem(foodItem1);
      final meal2 = Meal(name: 'Lunch');
      foodItem2.setGrams(200);
      foodItem3.setGrams(50);
      meal2.addFoodItem(foodItem2);
      meal2.addFoodItem(foodItem3);

      mealHolder.addMeal(meal1);
      mealHolder.addMeal(meal2);

      // Act
      mealHolder.calculateTotalNutrition();
      final totalNutrition = mealHolder.totalNutrition;

      // Assert
      expect(totalNutrition['calories'], 550.0);
      expect(totalNutrition['protein'], 30.0);
      expect(totalNutrition['fat'], 6.0);
      expect(totalNutrition['sugars'], 3.0);
      expect(totalNutrition['fiber'], 12.5);
      expect(totalNutrition['carbs'], 120.0);
    });

    test('MealHolder JSON serialization', () {
      // Arrange
      final mealHolder = MealHolder(date: DateTime.now());
      final foodItem =
          FoodItem(barcode: '12345', name: 'Test Food', nutritionInfo: {
        'calories': 100.0,
        'protein': 5.0,
        'fat': 1.0,
        'sugars': 0.5,
        'fiber': 2.0,
        'carbs': 20.0,
      });
      foodItem.setGrams(100);
      final meal = Meal(name: 'Breakfast');
      meal.addFoodItem(foodItem);
      mealHolder.addMeal(meal);

      // Act
      final json = mealHolder.toJson();
      final reconstructedMealHolder = MealHolder.fromJson(json);

      // Assert
      expect(reconstructedMealHolder.date.toIso8601String(),
          mealHolder.date.toIso8601String());
      expect(reconstructedMealHolder.meals.length, 1);
      expect(reconstructedMealHolder.meals[0].name, 'Breakfast');
    });
  });
}
