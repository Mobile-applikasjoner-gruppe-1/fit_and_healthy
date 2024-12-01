import 'package:fit_and_healthy/shared/widgets/charts/dounut_chart.dart';
import 'package:fit_and_healthy/shared/widgets/charts/horizontal_bar_chart.dart';
import 'package:flutter/material.dart';

class NutritionCard extends StatelessWidget {
  final double caloriesConsumed;
  final double totalCalories;
  final double carbs; // In grams
  final double fats; // In grams
  final double proteins; // In grams
  final double carbsGoal; // In grams
  final double fatsGoal; // In grams
  final double proteinsGoal; // In grams

  const NutritionCard({
    Key? key,
    required this.caloriesConsumed,
    required this.totalCalories,
    required this.carbs,
    required this.fats,
    required this.proteins,
    required this.carbsGoal,
    required this.fatsGoal,
    required this.proteinsGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: DonutChart(value: 1700, total: 3000, label: 'Calories'),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2, // Takes 2/3 of the space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HorizontalBarChart(
                    label: 'Protein',
                    value: 100,
                    goal: 150,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  HorizontalBarChart(
                    label: 'Carbs',
                    value: 100,
                    goal: 150,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  HorizontalBarChart(
                    label: 'Fat',
                    value: 100,
                    goal: 150,
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
