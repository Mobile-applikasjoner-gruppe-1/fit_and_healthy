import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/shared/widgets/charts/dounut_chart.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardCaloriesNutrition extends ConsumerWidget {
  final double caloriesConsumed;
  const CardCaloriesNutrition({
    super.key,
    required this.caloriesConsumed,
  });

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
                    'Calorie Intake',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  //Icon(Icons.monitor_weight, color: Colors.white),
                ],
              ),
            ),
            // Chart
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
