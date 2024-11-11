import 'package:flutter/material.dart';
import '../../../shared/models/exercise.dart';

// The ExerciseWorkoutCard widget
class ExerciseWorkoutCard extends StatelessWidget {
  const ExerciseWorkoutCard({
    super.key,
    required this.workout,
    required this.onSelectWorkout,
  });

  final Workout workout;
  final void Function() onSelectWorkout;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectWorkout,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.55),
              Colors.grey.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display workout title
            Text(
              workout.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 4),

            // Display workout time
            Text(
              "Time: ${workout.time}",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 12),

            // Display exercises label
            Text(
              "Exercises:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),

            // Display list of exercises, with a fallback message if no exercises are available
            if (workout.exercises.isEmpty)
              Text(
                "No exercises available",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: workout.exercises.map((exercise) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "- ${exercise.exerciseInfoList.name}",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
