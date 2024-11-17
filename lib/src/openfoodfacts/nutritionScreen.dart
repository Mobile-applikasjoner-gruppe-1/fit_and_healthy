// NutritionScreen.dart

import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'fooditemwidgets/foodSearchScreen.dart';
import 'mealCreationScreen.dart';

class NutritionScreen extends StatelessWidget {
  static const route = '/nutrition';
  static const routeName = 'Nutrition';

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(title: Text('Nutrition'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed(FoodSearchScreen.routeName);
              },
              child: Text('Add Food'),
            ),
            SizedBox(height: 20), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                context.pushNamed(MealListScreen.routeName);
              },
              child: Text(
                  'Create Meal'), // Button for navigating to MealBuilderWidget
            ),
          ],
        ),
      ),
    );
  }
}
