import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fit_and_healthy/shared/models/weight_entry.dart';

/// A widget that displays a line chart of weight entries over time using the `fl_chart` package.
/// The chart shows weight progression and provides a visual representation of user data.
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
    if (entries.isEmpty) return LineChartData();

    final earliestDate = entries.first.timestamp;
    final spots = entries.map((entry) {
      final x =
          entry.timestamp.difference(earliestDate).inMilliseconds.toDouble();
      return FlSpot(x / (24 * 60 * 60 * 1000), entry.weight.toDouble());
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
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
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
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final spot = spots.firstWhere(
                (spot) => spot.x == value,
                orElse: () => FlSpot.nullSpot,
              );
              if (spot.isNull()) return const SizedBox.shrink();

              final daysFromStart = spot.x.toInt();
              final date = earliestDate.add(Duration(days: daysFromStart));
              return Text(
                '${date.day}/${date.month}',
                style: const TextStyle(fontSize: 10),
              );
            },
            reservedSize: 30,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: false,
          spots: spots,
          barWidth: 4,
          color: Colors.lightBlue,
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
