import 'package:flutter/material.dart';

class CardAmountWeeklyWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Graph Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Placeholder(fallbackHeight: 100),
          ],
        ),
      ),
    ));
  }
}
