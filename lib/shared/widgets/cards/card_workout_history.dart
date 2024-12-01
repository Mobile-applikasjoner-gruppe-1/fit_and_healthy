import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryCard extends StatelessWidget {
  final List<Workout> workouts;

  const WorkoutHistoryCard({
    Key? key,
    required this.workouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<int, int> workoutCountsByWeek = _groupWorkoutsByWeek(workouts);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Workout History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Bar Chart
            SizedBox(
              height: 100,
              child: BarChart(
                _buildBarChartData(workoutCountsByWeek),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Groups the workouts by week, with the current week being index 0.
  Map<int, int> _groupWorkoutsByWeek(List<Workout> workouts) {
    final now = DateTime.now();
    final mondayOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));

    final Map<int, int> counts = {};
    for (final workout in workouts) {
      // Find the difference in days from the current week's Monday
      final daysFromMonday =
          workout.dateTime.difference(mondayOfCurrentWeek).inDays;

      // Calculate the week index
      final weekIndex = (daysFromMonday / 7).floor();

      // Initialize the count if it doesn't exist
      if (!counts.containsKey(weekIndex)) {
        counts[weekIndex] = 0;
      }

      // Increment the count for the respective week
      counts[weekIndex] = counts[weekIndex]! + 1;
    }

    return counts;
  }

  /// Builds the bar chart data for the given workout counts by week.
  BarChartData _buildBarChartData(Map<int, int> countsByWeek) {
    final barGroups = <BarChartGroupData>[];
    final maxWeeksToShow = 6; // Show the last 6 weeks.

    for (int i = 0; i <= maxWeeksToShow; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: countsByWeek[-i]?.toDouble() ?? 0.0,
              width: 16,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return BarChartData(
      gridData: FlGridData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, _) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              if (value.toInt() > 6) return const SizedBox.shrink();
              final monday = DateTime.now()
                  .subtract(Duration(days: value.toInt() * 7))
                  .subtract(Duration(days: DateTime.now().weekday - 1));
              final sunday = monday.add(const Duration(days: 6));
              return Text(
                '${DateFormat.Md().format(monday)}\n-\n${DateFormat.Md().format(sunday)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barGroups: barGroups,
    );
  }
}
