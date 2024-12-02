import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/shared/widgets/charts/dounut_chart.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_cache_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_date_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays a card showing the user's calorie intake progress.
/// The progress is visualized using a donut chart, which compares the consumed
/// calories to the total recommended calorie intake.
class CardCaloriesNutrition extends ConsumerWidget {
  const CardCaloriesNutrition({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(metricsControllerProvider);
    final nutritionDate = ref.watch(nutritionDateNotifierProvider);
    final nutritionCacheState = ref.watch(nutritionCacheNotifierProvider);

    // final now = DateTime.now();
    // final selectedDate = DateTime(now.year, now.month, now.day);

    // ref
    //     .read(nutritionCacheNotifierProvider.notifier)
    //     .listenToDate(selectedDate, true);

    final data = metricsState.value;

    if (data == null) {
      return const Center(child: Text('No data available.'));
    }

    final selectedDate = nutritionDate.value!;
    final meals = nutritionCacheState.maybeWhen(
      data: (data) => data.cachedDateMeals[selectedDate] ?? [],
      orElse: () => [],
    );

    final caloriesConsumed = meals.fold<double>(
      0.0,
      (sum, meal) => sum + meal.calculateTotalNutrition()['calories']!,
    );

    // TODO: Use the latest weigth from the controller, without callin the firestore
    final latestWeight = data.weightHistory.last;
    final height = data.height;
    final birthday = data.birthday;
    final gender = data.gender;
    final activityLevel = data.activityLevel;
    final weightGoal = data.weightGoal;

    final caloriesModel = CalorieCalculator.calculateCalories(
      height: height,
      birthday: birthday,
      weight: latestWeight.weight,
      gender: gender,
      activityLevel: activityLevel,
      weightGoal: weightGoal,
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
                children: [
                  Text(
                    'Calorie Intake',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: DonutChart(
                label: 'Calories',
                value: caloriesConsumed,
                total: caloriesModel.totalCalorie,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
