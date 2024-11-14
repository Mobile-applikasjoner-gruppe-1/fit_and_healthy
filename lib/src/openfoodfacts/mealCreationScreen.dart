import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/mealClass.dart';
import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/mealHolderClass.dart';
import 'package:flutter/material.dart';

import 'mealDetailScreen.dart';

class MealListScreen extends StatefulWidget {
  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final MealHolder mealHolder =
      MealHolder(date: DateTime.now()); // Initialize with current date

  void _addMeal(String name) {
    setState(() {
      mealHolder.addMeal(Meal(name: name));
    });
  }

  void _removeMeal(String mealId) {
    setState(() {
      mealHolder.removeMeal(mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalNutrition = mealHolder.calculateTotalNutrition();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Meals on ${mealHolder.date.toLocal().toString().split(' ')[0]}'), // Display date
      ),
      body: Column(
        children: [
          // Display total nutrition for all meals in the MealHolder
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Nutrition for All Meals:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                    'Calories: ${totalNutrition['calories']!.toStringAsFixed(2)} kcal'),
                Text(
                    'Protein: ${totalNutrition['protein']!.toStringAsFixed(2)} g'),
                Text('Fat: ${totalNutrition['fat']!.toStringAsFixed(2)} g'),
                Text(
                    'Sugars: ${totalNutrition['sugars']!.toStringAsFixed(2)} g'),
                Text('Fiber: ${totalNutrition['fiber']!.toStringAsFixed(2)} g'),
                Text('Carbs: ${totalNutrition['carbs']!.toStringAsFixed(2)} g'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mealHolder.meals.length,
              itemBuilder: (context, index) {
                final meal = mealHolder.meals[index];
                return ListTile(
                  title: Text(meal.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeMeal(meal.id), // Remove meal by ID
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(meal: meal),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          String? name = await _showAddMealDialog(context);
          if (name != null && name.isNotEmpty) {
            _addMeal(name);
          }
        },
      ),
    );
  }

  Future<String?> _showAddMealDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Meal'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter meal name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        );
      },
    );
  }
}
