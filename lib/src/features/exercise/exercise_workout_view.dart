import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_workout_detail.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_workout_item.dart';

/**
 * The ExerciseView widget displays a list of workouts, allowing users to view available
 * workout sessions or navigate to a detailed view of a selected workout.
 * 
 * Features:
 * - Displays a message if no workouts are available.
 * - Lists all workouts using ExerciseWorkoutItem widgets.
 * - Navigates to the WorkoutDetailView when a workout is selected.
 */
class ExerciseView extends StatelessWidget {
  const ExerciseView({
    super.key,
    required this.workouts,
  });

  final List<Workout> workouts; // List of workouts to be displayed in the view.

  /**
   * Navigates to the WorkoutDetailView for the selected workout.
   * 
   * [context] - The BuildContext of the widget.
   * [workout] - The selected Workout object to be passed to the detail view.
   */
  void selectWorkout(BuildContext context, Workout workout) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => WorkoutDetailView(
          workout: workout,
        ),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!'
          ),
          const SizedBox(height: 16),
          Text(
            'Try adding a workout session!',
          ),
        ],
      ),
    );

    if (workouts.isNotEmpty) {
      content = ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (ctx, index) => ExerciseWorkoutItem(
          workout: workouts[index],
          onSelectWorkout: (workout) {
            selectWorkout(context, workout);
          },
        ),
      );

      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts!'),
      ),
      body: content,
    );
  }
}

