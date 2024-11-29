import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/fooditem.dart';
import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/mealClass.dart';
import 'package:fit_and_healthy/src/openfoodfacts/openFoodApi.dart';
import 'package:flutter_test/flutter_test.dart';

/// This class uses real world data, used print statement because values can change by producers of products
void main() {
  final api = OpenFoodApi();

  group('Meal Nutrition Calculation', () {
    test('Add food items by barcode and calculate total nutrition', () async {
      final meal = Meal(name: 'Dinner', timestamp: DateTime.now(), id: '1');

      // List of test items with their barcodes and desired grams
      final testItems = [
        {
          'barcode': '7039610001131',
          'grams': 150.0
        }, // e.g., 150g of an chicken
        {'barcode': '7040512040395', 'grams': 120.0}, // e.g., 120g of a potatos
        {
          'barcode': '7037610231985',
          'grams': 14.0
        }, // e.g., 14g of an Barnesauce
      ];

      // Display the name of the items and adds the total grams of each
      for (var item in testItems) {
        final barcode = item['barcode'] as String;
        final grams = item['grams'] as double;

        // Fetch the FoodItem by barcode using OpenFoodApi
        final result = await api.fetchProductByBarcode(barcode);
        if (result != null) {
          final foodItem = FoodItem.fromFoodFactsJson(result);
          meal.addFoodItem(foodItem);
          print('Added ${foodItem.name} (${grams}g) to the meal.');
        } else {
          print('No food item found for barcode: $barcode');
        }
      }

      // Calculate and display the total nutrition for the meal
      print('\nTotal Nutrition for Meal:');
      final totalNutrition = meal.calculateTotalNutrition();
      totalNutrition.forEach((key, value) {
        print('$key: ${value.toStringAsFixed(2)}');
      });

      // Assertions to verify non-zero nutrition values
      expect(totalNutrition.isNotEmpty, true);
      expect(totalNutrition['calories'] ?? 0, greaterThan(0));
      expect(totalNutrition['protein'] ?? 0, greaterThan(0));
      expect(totalNutrition['carbs'] ?? 0, greaterThan(0));
    });
  });
}
