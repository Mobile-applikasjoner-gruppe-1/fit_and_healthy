import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A widget that displays a donut-style chart using the `fl_chart` package.
/// The chart represents a proportion of a value out of a total, along with a label.
class DonutChart extends StatelessWidget {
  final double value;
  final double total;
  final String label;

  const DonutChart({
    Key? key,
    required this.value,
    required this.total,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: value,
                  color: Colors.blue,
                  radius: 20,
                  title: '',
                ),
                PieChartSectionData(
                  value: total - value,
                  color: Colors.grey.shade300,
                  radius: 20,
                  title: '',
                ),
              ],
              centerSpaceRadius: 50,
              sectionsSpace: 0,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${value.toInt()} / ${total.toInt()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
