import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

/**
 * The ExerciseItem displays detailed information about a single exercise, including 
 * its category, description, sets (with repetitions and weight), and any optional notes. 
 * 
 * Features:
 * - Displays the exercise category and description.
 * - Lists sets with repetitions, weight, and optional set type.
 * - Shows an optional note if provided for the exercise.
 */
class ExerciseItem extends StatelessWidget {
  const ExerciseItem({
    super.key,
    required this.exercise,
  });

  final Exercise exercise; // The exercise to be displayed.


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              "Category: ${exercise.exerciseInfoList.exerciseCategory.toString().split('.').last}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              exercise.exerciseInfoList.info,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Text(
              "Sets:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: exercise.sets.map((set) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "${set.repititions} reps at ${set.weight} kg" +
                        (set.exerciseSetType != null ? " (${set.exerciseSetType.toString().split('.').last})" : ""),
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            if (exercise.note != null)
              Text(
                "Note: ${exercise.note}",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}