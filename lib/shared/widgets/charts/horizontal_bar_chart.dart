import 'package:flutter/material.dart';

/// A widget that displays a horizontal progress bar representing a value compared to a goal.
/// The progress bar is color-coded and includes a label with the current and goal values.
class HorizontalBarChart extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color color;

  const HorizontalBarChart({
    Key? key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label (${value.toInt()} / ${goal.toInt()}g)',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade300,
              ),
            ),
            FractionallySizedBox(
              widthFactor: (value / goal).clamp(0.0, 1.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
