import 'package:fit_and_healthy/shared/widgets/charts/horizontal_bar_chart.dart';
import 'package:flutter/material.dart';

class CardMacroNutritions extends StatelessWidget {
  final double carbs; // In grams
  final double fats; // In grams
  final double proteins; // In grams
  final double carbsGoal; // In grams
  final double fatsGoal; // In grams
  final double proteinsGoal; // In grams

  const CardMacroNutritions({
    Key? key,
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
            // Title and Icon
            Padding(
              padding: const EdgeInsets.all(16),
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
                  //Icon(Icons.monitor_weight, color: Colors.white),
                ],
              ),
            ),
            // Chart
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
