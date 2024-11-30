import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/widgets/exercise_item.dart';

/**
 * The WorkoutDetailView widget displays detailed information about a single workout,
 * including the workout date and a list of exercises within the workout.
 * 
 * Features:
 * - Lists exercises included in the workout, each represented by an ExerciseItem widget.
 * - Displays a message if no exercises are available in the workout.
 */
class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({super.key, required this.workoutId, required this.workouts});

  final String workoutId; // The workout to be displayed.
  final List<Workout> workouts;

  /**
 * Retrieves a Workout object from the sampleWorkouts list using the provided workoutId.
 *
 * Functionality:
 * - Converts the workoutId (String) to an integer.
 * - Searches the sampleWorkouts list for a workout with a matching ID.
 * - Throws an exception if:
 *   - The workoutId is not a valid integer.
 *   - No workout with the given ID is found.
 *
 * Parameters:
 * - [workoutId] (String): The ID of the workout to retrieve.
 *
 * Returns:
 * - [Workout]: The workout object matching the provided ID.
 *
 * Throws:
 * - Exception if the workoutId is invalid or the workout is not found.
 */
  Workout _getWorkoutById(String workoutId) {
    final id = int.tryParse(workoutId);
    if (id == null) {
      throw Exception('Invalid workout ID: $workoutId');
    }

    return workouts.firstWhere(
      (workout) => workout.id == workoutId,
      orElse: () {
        throw Exception('Workout with id $workoutId not found');
      },
    );
  }

  /**
   * The formatDate method, format the date as 'MMM d, yyyy'. 
   * This could be for example, 'November 13, 2024'
   */
  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final workout = _getWorkoutById(workoutId);
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

    return NestedScaffold(
      appBar: AppBar(
        title: Text(workout.title),
      ),
      body: content,
    );
  }
}
