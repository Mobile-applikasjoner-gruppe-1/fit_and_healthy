import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/shared/widgets/charts/horizontal_bar_chart.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_cache_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_date_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays a card showing the user's macronutrient progress.
/// The progress is visualized using horizontal bar charts for protein, carbs, and fats.
/// Each bar shows the consumed value versus the recommended goal based on user metrics.
class CardMacroNutritions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(metricsControllerProvider);
    final nutritionDate = ref.watch(nutritionDateNotifierProvider);
    final nutritionCacheState = ref.watch(nutritionCacheNotifierProvider);

    if (metricsState.value == null || nutritionDate.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final metricsData = metricsState.value!;
    final selectedDate = nutritionDate.value!;
    final meals = nutritionCacheState.maybeWhen(
      data: (data) => data.cachedDateMeals[selectedDate] ?? [],
      orElse: () => [],
    );

    // Calculate consumed macronutrients
    final macronutrients = meals.fold<Map<String, double>>(
      {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
      (accumulated, meal) {
        final mealNutrition = meal.calculateTotalNutrition();
        return {
          'protein': accumulated['protein']! + mealNutrition['protein']!,
          'carbs': accumulated['carbs']! + mealNutrition['carbs']!,
          'fats': accumulated['fats']! + mealNutrition['fat']!,
        };
      },
    );

    // Calculate recommended macronutrients
    final caloriesModel = CalorieCalculator.calculateCalories(
      height: metricsData.height,
      birthday: metricsData.birthday,
      weight: metricsData.weightHistory.last.weight,
      gender: metricsData.gender,
      activityLevel: metricsData.activityLevel,
      weightGoal: metricsData.weightGoal,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.green.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Macronutrients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HorizontalBarChart(
                    label: 'Protein',
                    value: macronutrients['protein']!,
                    goal: caloriesModel.recommendedProtein,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 8),
                  HorizontalBarChart(
                    label: 'Carbs',
                    value: macronutrients['carbs']!,
                    goal: caloriesModel.recommendedCarbs,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 8),
                  HorizontalBarChart(
                    label: 'Fat',
                    value: macronutrients['fats']!,
                    goal: caloriesModel.recommendedFats,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
