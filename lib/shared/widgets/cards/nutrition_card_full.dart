import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/shared/widgets/charts/dounut_chart.dart';
import 'package:fit_and_healthy/shared/widgets/charts/horizontal_bar_chart.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_cache_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_date_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays a user's nutritional metrics, including:
/// - Calories consumed vs total calories.
/// - Macronutrient (proteins, carbs, fats) progress vs goals.
///
/// The card dynamically calculates the user's recommended calories and macronutrient goals
/// based on their personal metrics and activity level.
class NutritionCard extends ConsumerWidget {
  const NutritionCard({Key? key}) : super(key: key);

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

    // Calculate consumed calories and macronutrients
    final macronutrients = meals.fold<Map<String, double>>(
      {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0, 'calories': 0.0},
      (accumulated, meal) {
        final mealNutrition = meal.calculateTotalNutrition();
        return {
          'protein': accumulated['protein']! + mealNutrition['protein']!,
          'carbs': accumulated['carbs']! + mealNutrition['carbs']!,
          'fats': accumulated['fats']! + mealNutrition['fat']!,
          'calories': accumulated['calories']! + mealNutrition['calories']!,
        };
      },
    );

    // Calculate recommended calories and macronutrients
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
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Nutrition Summary',
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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: DonutChart(
                      value: macronutrients['calories']!,
                      total: caloriesModel.totalCalorie,
                      label: 'Calories',
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
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
          ],
        ),
      ),
    );
  }
}
