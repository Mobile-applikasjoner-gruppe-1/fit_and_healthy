import 'package:fit_and_healthy/shared/widgets/charts/workout_bar_cart_weekly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardWeeklyWorkout extends ConsumerWidget {
  const CardWeeklyWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.blue.shade300,
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
            SizedBox(
              height: 100, // Fixed height for chart
              child: WeeklyExerciseChart(
                completedExercises: 4,
                weeklyGoal: 3,
              ), // Reuse WeightChart
            ),
          ],
        ),
      ),
    );
  }
}
