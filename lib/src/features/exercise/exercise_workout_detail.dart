import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_item.dart';

/**
 * The WorkoutDetailView widget displays detailed information about a single workout,
 * including the workout date and a list of exercises within the workout.
 * 
 * Features:
 * - Lists exercises included in the workout, each represented by an ExerciseItem widget.
 * - Displays a message if no exercises are available in the workout.
 */
class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({
    super.key,
    required this.workout
  });

  final Workout workout; // The workout to be displayed.

  /**
   * The formatDate method, format the date as 'MMM d, yyyy'. 
   * This could be for example, 'November 13, 2024'
   */
  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Workout Date: ${_formatDate(workout.dateTime)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (workout.exercises.isEmpty)
            Center(
              child: Text(
                "No exercises available",
                style: TextStyle(fontSize: 16),
              ),
            )
          else
            Column(
              children: workout.exercises.map((exercise) {
                return ExerciseItem(exercise: exercise);
              }).toList(),
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.title),
      ),
      body: content,
    );
  }
}
