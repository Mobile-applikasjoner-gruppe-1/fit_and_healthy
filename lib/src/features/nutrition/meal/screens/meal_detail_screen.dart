import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_item_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_cache_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/open_food_api.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/widgets/food_item_widget.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:fit_and_healthy/src/utils/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  static const route = '/meal/:id';
  static const routeName = 'Meal Details';

  MealDetailScreen({required this.mealId});

  final String mealId;

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final OpenFoodApi _openFoodApi = OpenFoodApi();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  // Search products by name
  void _searchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final results =
          await _openFoodApi.searchProductsByName(_searchController.text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Add a FoodItem to the meal
  // void _addProductToMeal(Map<String, dynamic> product, double grams) {
  //   final foodItem = FoodItem(
  //     name: product['product_name'] ?? 'Unknown Product',
  //     barcode: product['code'] ?? 'No Barcode',
  //     imageUrl: product['image_url'],
  //     ingredients: product['ingredients_text'],
  //     allergens: product['allergens'],
  //     servingSize: product['serving_size'],
  //     nutritionInfo: {
  //       'calories': (product['nutriments']['energy-kcal_100g'] ?? 0).toDouble(),
  //       'protein': (product['nutriments']['proteins_100g'] ?? 0).toDouble(),
  //       'fat': (product['nutriments']['fat_100g'] ?? 0).toDouble(),
  //       'sugars': (product['nutriments']['sugars_100g'] ?? 0).toDouble(),
  //       'fiber': (product['nutriments']['fiber_100g'] ?? 0).toDouble(),
  //       'carbs': (product['nutriments']['carbohydrates_100g'] ?? 0).toDouble(),
  //     },
  //     grams: grams,
  //   );
  // }

  // Edit grams of an existing food item
  // void _editFoodItemGrams(int index, double grams) {
  //   setState(() {
  //     widget.meal.items[index].setGrams(grams);
  //   });
  // }

  // Remove a food item from the meal

  @override
  Widget build(BuildContext context) {
    Widget content;
    Meal? meal;

    String mealId = widget.mealId;

    final nutritionCacheState = ref.watch(nutritionCacheNotifierProvider);

    void _removeFoodItem(String mealItemId) {
      ref.read(mealItemControllerProvider.notifier).removeItemFromMeal(
            mealId,
            mealItemId,
          );
    }

    void _addFoodItem(FoodItem foodItem) {
      ref.read(mealItemControllerProvider.notifier).addItemsToMeal(
        mealId,
        [foodItem],
      );
    }

    void _editFoodItemGrams(String mealItemId, double grams) {
      final item = meal?.items.firstWhere((item) => item.id == mealItemId);
      if (item != null) {
        item.setGrams(grams);
      }

      ref.read(mealItemControllerProvider.notifier).updateMealItemGrams(
            mealId,
            mealItemId,
            grams,
          );
    }

    if (nutritionCacheState is AsyncLoading) {
      content = Center(child: CircularProgressIndicator());
    } else if (nutritionCacheState is AsyncError) {
      content = Center(child: Text('Error: ${nutritionCacheState.error}'));
    } else {
      meal = nutritionCacheState.value?.cachedMeals[mealId];

      if (meal == null) {
        content = Center(child: Text('Meal not found'));
      } else {
        final totalNutrition = meal.calculateTotalNutrition();
        content = SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Meal Date: ${formatDate(meal.timestamp)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Nutrition for Meal:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    for (var nutrient in totalNutrition.entries)
                      Text(
                          '${nutrient.key}: ${nutrient.value.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (meal.items.isEmpty)
                Center(
                  child: Text(
                    "No meal items available",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              else
                Column(
                  children: meal.items.map((item) {
                    return FoodItemWidget(foodItem: item);
                  }).toList(),
                ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a food item',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchProducts,
                ),
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading) CircularProgressIndicator(),

          // Search Results List
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return ListTile(
                  title: Text(product['product_name'] ?? 'Unknown Product'),
                  subtitle: Text('Barcode: ${product['code'] ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showAddToMealDialog(product);
                    },
                  ),
                );
              },
            ),
          ),

          // Display meal items with options to edit grams and delete item
          Expanded(
            child: ListView.builder(
              itemCount: meal?.items.length ?? 0,
              itemBuilder: (context, index) {
                final item = meal!.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.grams} grams'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () => showFoodItemInfoDialog(context, item),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (item.id != null) {
                            _showEditGramsDialog(
                                (grams) => _editFoodItemGrams(item.id!, grams),
                                item.grams);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if (item.id != null) {
                            _removeFoodItem(item.id!);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Total Nutrition Summary
        ],
      ),
    );
  }

  // Dialog to specify grams before adding product to the meal
  void _showAddToMealDialog(Map<String, dynamic> product) {
    final TextEditingController gramsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${product['product_name']} to Meal'),
        content: TextField(
          controller: gramsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Enter weight in grams'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final grams = double.tryParse(gramsController.text) ?? 0.0;
              if (grams > 0) {
                // _addProductToMeal(product, grams);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Dialog to edit grams of an existing food item
  void _showEditGramsDialog(Function(double) setGrams, double currentGrams) {
    final TextEditingController gramsController =
        TextEditingController(text: currentGrams.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Grams'),
        content: TextField(
          controller: gramsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Enter new weight in grams'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final grams =
                  double.tryParse(gramsController.text) ?? currentGrams;
              if (grams > 0) {
                setGrams(grams);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
