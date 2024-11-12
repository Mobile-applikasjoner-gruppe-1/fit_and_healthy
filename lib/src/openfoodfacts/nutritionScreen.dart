// NutritionScreen.dart

import 'package:flutter/material.dart';

import 'fooditemwidgets/foodSearchScreen.dart';
import 'mealCreationScreen.dart';

class NutritionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodSearchScreen()),
                );
              },
              child: Text('Add Food'),
            ),
            SizedBox(height: 20), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealListScreen()),
                );
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
