import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_cache_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_date_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/screens/meal_creation_screen.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/screens/meal_detail_screen.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/widgets/meal_view.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/**
   * Navigates to the WorkoutDetailView for the selected workout.
   *
   * Functionality:
   * - Converts the workout's integer ID to a string, as GoRouter expects path parameters to be strings.
   * - Uses the GoRouter's `context.push` method to navigate to the WorkoutDetailView.
   * - Appends the workout ID to the route path as a path parameter.
   */
void selectMeal(BuildContext context, Meal meal) {
  context
      .pushNamed(MealDetailScreen.routeName, pathParameters: {'id': meal.id});
}

void navigateToAddMeal(BuildContext context) {
  context.pushNamed(MealCreationScreen.routeName);
}

class MealListScreen extends ConsumerWidget {
  static const route = '/nutrition';
  static const routeName = 'Nutrition';

  _getTotalNutrition(List<Meal>? meals) {
    final totalNutrition = {
      'calories': 0.0,
      'protein': 0.0,
      'fat': 0.0,
      'sugars': 0.0,
      'fiber': 0.0,
      'carbs': 0.0,
    };

    if (meals == null) {
      return totalNutrition;
    }

    for (var meal in meals) {
      final mealNutrition = meal.calculateTotalNutrition();
      totalNutrition['calories'] =
          totalNutrition['calories']! + mealNutrition['calories']!;
      totalNutrition['protein'] =
          totalNutrition['protein']! + mealNutrition['protein']!;
      totalNutrition['fat'] = totalNutrition['fat']! + mealNutrition['fat']!;
      totalNutrition['sugars'] =
          totalNutrition['sugars']! + mealNutrition['sugars']!;
      totalNutrition['fiber'] =
          totalNutrition['fiber']! + mealNutrition['fiber']!;
      totalNutrition['carbs'] =
          totalNutrition['carbs']! + mealNutrition['carbs']!;
    }

    return totalNutrition;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget? loggedMeals;
    Widget content = const Center(child: Text('temp'));
    Widget? nutritionSummary;

    final nutritionDate = ref.watch(nutritionDateNotifierProvider);
    final nutritionCacheState = ref.watch(nutritionCacheNotifierProvider);

    DateTime? selectedDate;

    if (nutritionDate is AsyncLoading) {
      loggedMeals = const Center(child: CircularProgressIndicator());
    } else if (nutritionDate is AsyncError) {
      loggedMeals = Center(child: Text('Error: ${nutritionDate.error}'));
    } else {
      selectedDate = nutritionDate.value;
      if (selectedDate == null) {
        loggedMeals = const Center(child: CircularProgressIndicator());
      } else {
        final mealNotifier = ref.read(nutritionCacheNotifierProvider.notifier);
        mealNotifier.listenToDate(selectedDate, true);

        if (nutritionCacheState is AsyncLoading) {
          loggedMeals = const Center(child: CircularProgressIndicator());
        } else if (nutritionCacheState is AsyncError) {
          loggedMeals =
              Center(child: Text('Error: ${nutritionCacheState.error}'));
        } else {
          if (nutritionCacheState.value == null) {
            loggedMeals = const Center(child: CircularProgressIndicator());
          }

          final meals =
              nutritionCacheState.value!.cachedDateMeals[selectedDate];

          if (meals == null || meals.isEmpty) {
            loggedMeals = const Text(
              'No meals logged',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            );
          } else {
            final totalNutrition = _getTotalNutrition(meals);
            nutritionSummary = Padding(
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
                  Text(
                      'Fiber: ${totalNutrition['fiber']!.toStringAsFixed(2)} g'),
                  Text(
                      'Carbs: ${totalNutrition['carbs']!.toStringAsFixed(2)} g'),
                ],
              ),
            );

            loggedMeals = ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meals.length,
              itemBuilder: (ctx, index) => MealView(
                meal: meals[index],
                onSelect: (meal) {
                  selectMeal(context, meal);
                },
              ),
            );
          }
        }

        content = SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => navigateToAddMeal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Add Meal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (nutritionSummary != null) ...[
                    const SizedBox(height: 16),
                    nutritionSummary,
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Logged',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  if (loggedMeals != null) ...[
                    loggedMeals,
                  ],
                ],
              ),
            ),
          ),
        );
      }
    }

    return NestedScaffold(
      appBar: AppBar(
        title: Text('Nutrition'),
        centerTitle: true,
      ),
      body: content,
    );

// Old code:
    // return Scaffold(
    //         appBar: AppBar(
    //           title: Text(
    //             'Meals on ${selectedDate?.toLocal().toString().split(' ')[0] ?? 'No Date Selected'}',
    //           ),
    //         ),
    //         body:
    //         // TODO: Display content here instead
    //         Column(
    //           children: [
    //             // Display total nutrition
    //             Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text('Total Nutrition for All Meals:',
    //                       style: TextStyle(
    //                           fontSize: 18, fontWeight: FontWeight.bold)),
    //                   Text(
    //                       'Calories: ${totalNutrition['calories']!.toStringAsFixed(2)} kcal'),
    //                   Text(
    //                       'Protein: ${totalNutrition['protein']!.toStringAsFixed(2)} g'),
    //                   Text(
    //                       'Fat: ${totalNutrition['fat']!.toStringAsFixed(2)} g'),
    //                   Text(
    //                       'Sugars: ${totalNutrition['sugars']!.toStringAsFixed(2)} g'),
    //                   Text(
    //                       'Fiber: ${totalNutrition['fiber']!.toStringAsFixed(2)} g'),
    //                   Text(
    //                       'Carbs: ${totalNutrition['carbs']!.toStringAsFixed(2)} g'),
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //               child: ListView.builder(
    //                 itemCount: mealHolder.meals.length,
    //                 itemBuilder: (context, index) {
    //                   final meal = mealHolder.meals[index];
    //                   return ListTile(
    //                     title: Text(meal.name),
    //                     trailing: IconButton(
    //                       icon: Icon(Icons.delete),
    //                       onPressed: () => ref
    //                           .read(mealControllerProvider.notifier)
    //                           .removeMeal(meal.id),
    //                     ),
    //                     onTap: () {
    //                       context.pushNamed(MealDetailScreen.routeName, pathParameters: {'mealId': meal.id});
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //         floatingActionButton: FloatingActionButton(
    //           child: Icon(Icons.add),
    //           onPressed: () async {
    //             context.pushNamed(MealCreationScreen.routeName);
    //           },
    //         ),
    //       );
  }
}

// TODO: Remove this and implement entering name on the MealCreationScreen
// Future<String?> _showAddMealDialog(BuildContext context) {
//   final TextEditingController controller = TextEditingController();
//   return showDialog<String>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('New Meal'),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(hintText: 'Enter meal name'),
//         ),
//         actions: [
//           TextButton(
//             child: Text('Cancel'),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: Text('Add'),
//             onPressed: () => Navigator.pop(context, controller.text),
//           ),
//         ],
//       );
//     },
//   );
// }
