import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/shared/widgets/charts/horizontal_bar_chart.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays a card showing the user's macronutrient progress.
/// The progress is visualized using horizontal bar charts for protein, carbs, and fats.
/// Each bar shows the consumed value versus the recommended goal based on user metrics.
class CardMacroNutritions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(metricsControllerProvider);

    final data = metricsState.value;

    if (data == null) {
      return const Center(child: Text('No data available.'));
    }

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
                    'Weekly workout',
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
              child: Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HorizontalBarChart(
                      label: 'Protein',
                      value: 100,
                      goal: caloriesModel.recommendedProtein,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: 8),
                    HorizontalBarChart(
                      label: 'Carbs',
                      value: 100,
                      goal: caloriesModel.recommendedCarbs,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    HorizontalBarChart(
                      label: 'Fat',
                      value: 100,
                      goal: caloriesModel.recommendedFats,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
