import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

/**
 * The ExerciseWorkoutItem widget displays a summary of a workout, including its title,
 * date, and the list of exercises. This widget displays all workout sessions where each 
 * workout can be tapped to view more details.
 * 
 * Features:
 * - Displays the workout title and formatted date.
 * - Lists exercises, or showing a message if no exercises are available.
 * - Responds to tap events to allow navigation to a detailed workout screen.
 */
class ExerciseWorkoutItem extends StatelessWidget {
  const ExerciseWorkoutItem({
    super.key,
    required this.workout,
    required this.onSelectWorkout
  });

  final Workout workout; // The workout to be displayed.
  final void Function(Workout workout) onSelectWorkout; // Callback function when workout is tapped.

  /**
   * The formatDate method, format the date as 'MMM d, yyyy'. 
   * This could be for example, 'November 13, 2024'
   */
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
          onSelectWorkout(workout);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(workout.dateTime),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(Icons.fitness_center, size: 18),
                  const SizedBox(width: 4),
                  Text("Exercises:"),
                ],
              ),
              const SizedBox(height: 8),

              if (workout.exercises.isEmpty)
                Text("No exercises available")
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workout.exercises.map((exercise) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "- ${exercise.exerciseInfoList.name}",
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