import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';

class WeightChart extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightChart({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No weight data available.',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LineChart(
        _buildLineChart(entries),
      ),
    );
  }

  LineChartData _buildLineChart(List<WeightEntry> entries) {
    final earliestDate = entries.first.timestamp;
    final spots = entries.map((entry) {
      final x = entry.timestamp.difference(earliestDate).inDays.toDouble();
      return FlSpot(x, entry.weight.toDouble());
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        horizontalInterval: 5,
        verticalInterval: 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.5),
          strokeWidth: 0.5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.5),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false, // Remove top titles
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // Keep kg text on the left
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}kg',
                style: const TextStyle(fontSize: 10),
              );
            },
            reservedSize: 40,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // Keep dates on the bottom
            getTitlesWidget: (value, meta) {
              final int daysFromStart = value.toInt();
              final date = earliestDate.add(Duration(days: daysFromStart));
              return Text(
                '${date.day}/${date.month}',
                style: const TextStyle(fontSize: 10),
              );
            },
            reservedSize: 30,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false, // Remove right titles
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: spots,
          barWidth: 4,
          color: Colors.blue,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.3),
                Colors.blue.withOpacity(0)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
    );
  }
}
