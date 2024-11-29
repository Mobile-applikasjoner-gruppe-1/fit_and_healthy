import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/open_food_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final api = OpenFoodApi();

  group('OpenFoodApi', () {
    test('searchProductsByName returns a list of FoodItems', () async {
      final results = await api.searchProductsByName('Kalkunfilet Naturell');
      final foodItems =
          results.map((json) => FoodItem.fromFoodFactsJson(json)).toList();

      expect(foodItems.isNotEmpty, true);
      expect(foodItems.first.name.isNotEmpty, true);
      print(
          'Test passed: searchProductsByName returned ${foodItems.length} items');
    });

    test('fetchProductByBarcode returns a FoodItem for a valid barcode',
        () async {
      final barcode = '7622300336738';
      final result = await api.fetchProductByBarcode(barcode);

      if (result != null) {
        final foodItem = FoodItem.fromFoodFactsJson(result);
        expect(foodItem.name.isNotEmpty, true);
        expect(foodItem.nutritionInfo.isNotEmpty, true);
        print('Test passed: fetchProductByBarcode returned a valid product');
      } else {
        fail('No product found for barcode');
      }
    });

    test('fetchProductByBarcode returns null for an invalid barcode', () async {
      final barcode = '0234152134'; // Likely invalid barcode
      final result = await api.fetchProductByBarcode(barcode);
      expect(result, isNull);
      print(
          'Test passed: fetchProductByBarcode returned null for invalid barcode');
    });
  });
}
