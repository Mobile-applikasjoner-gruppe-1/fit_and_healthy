import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Displays the details of a meal in a card.
/// Should be used in lists of meals
class MealView extends StatelessWidget {
  final Meal meal;
  final Function(Meal) onSelect;

  const MealView({super.key, required this.meal, required this.onSelect});

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          onSelect(meal);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(meal.timestamp),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.restaurant, size: 16),
                  const SizedBox(width: 4),
                  Text("Items:"),
                ],
              ),
              const SizedBox(height: 8),
              if (meal.items.isEmpty)
                Text("No items available")
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: meal.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "- ${item.name}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
