import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/meal_item_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealCreationScreen extends ConsumerStatefulWidget {
  static const route = 'create';
  static const routeName = 'Create Meal';

  @override
  _MealCreationScreenState createState() => _MealCreationScreenState();
}

class _MealCreationScreenState extends ConsumerState<MealCreationScreen> {
  Meal _getMealFromFields() {
    // TODO: Implement getting meal from fields in form
    final meal = Meal(
      id: '1',
      name: 'New Meal',
      timestamp: DateTime.now(),
    );

    // TODO: Implement getting meal from UI
    meal.items.add(
      FoodItem(
        id: '1',
        name: 'Item 1',
        barcode: '1234567890',
        nutritionInfo: {
          'calories': 100,
          'protein': 10,
          'fat': 5,
          'sugars': 5,
          'fiber': 2,
          'carbs': 20,
        },
      ),
    );

    return meal;
  }

  void _createMeal() async {
    final meal = _getMealFromFields();

    print(meal);

    final mealController = ref.read(mealControllerProvider.notifier);
    final mealItemController = ref.read(mealItemControllerProvider.notifier);

    final id = await mealController.addMeal(meal);

    await mealItemController.addItemsToMeal(id, meal.items);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meal added successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    if (context.canPop()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add form to create a meal with a searchfield and camera to add items
    return NestedScaffold(
      appBar: AppBar(
        title: Text('Create Meal'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _createMeal,
          ),
        ],
      ),
      body: Center(
        child: Text('Create Meal'),
      ),
    );
  }
}
