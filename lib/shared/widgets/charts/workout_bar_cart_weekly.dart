import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyExerciseChart extends StatelessWidget {
  final int completedExercises;
  final int weeklyGoal;

  const WeeklyExerciseChart({
    Key? key,
    required this.completedExercises,
    required this.weeklyGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        _buildBarChart(),
      ),
    );
  }

  BarChartData _buildBarChart() {
    return BarChartData(
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: completedExercises.toDouble(),
              width: 20,
              color:
                  completedExercises >= weeklyGoal ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ],
      gridData: FlGridData(
        show: true,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: value == weeklyGoal
              ? Colors.orange
              : Colors.grey.withOpacity(0.5),
          strokeWidth: value == weeklyGoal ? 2 : 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      barTouchData: BarTouchData(enabled: false),
      maxY: (weeklyGoal + 1).toDouble(), // Adjust to include goal line
    );
  }
}
