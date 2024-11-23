import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/meal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mealDetailScreen.dart';

class MealListScreen extends ConsumerWidget {
  static const route = '/create-meal';
  static const routeName = 'Create Meal';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealHolderFuture = ref.watch(mealControllerProvider.future);

    return FutureBuilder(
      future: mealHolderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No meals found.'));
        } else {
          final mealHolder = snapshot.data!;
          final totalNutrition = mealHolder.totalNutrition;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Meals on ${mealHolder.date.toLocal().toString().split(' ')[0]}',
              ),
            ),
            body: Column(
              children: [
                // Display total nutrition
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Nutrition for All Meals:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                          'Calories: ${totalNutrition['calories']!.toStringAsFixed(2)} kcal'),
                      Text(
                          'Protein: ${totalNutrition['protein']!.toStringAsFixed(2)} g'),
                      Text(
                          'Fat: ${totalNutrition['fat']!.toStringAsFixed(2)} g'),
                      Text(
                          'Sugars: ${totalNutrition['sugars']!.toStringAsFixed(2)} g'),
                      Text(
                          'Fiber: ${totalNutrition['fiber']!.toStringAsFixed(2)} g'),
                      Text(
                          'Carbs: ${totalNutrition['carbs']!.toStringAsFixed(2)} g'),
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
                          onPressed: () => ref
                              .read(mealControllerProvider.notifier)
                              .removeMeal(meal.id),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MealDetailScreen(meal: meal),
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
                  ref.read(mealControllerProvider.notifier).addMeal(name);
                }
              },
            ),
          );
        }
      },
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
