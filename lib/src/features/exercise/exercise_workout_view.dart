import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_workout_item.dart';
import 'package:go_router/go_router.dart';

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
  const ExerciseView({super.key, required this.workouts});

  static const route = '/exercise';
  static const routeName = 'Exercise';

  final List<Workout> workouts; // List of workouts to be displayed in the view.

  /**
   * Navigates to the WorkoutDetailView for the selected workout.
   *
   * Functionality:
   * - Converts the workout's integer ID to a string, as GoRouter expects path parameters to be strings.
   * - Uses the GoRouter's `context.push` method to navigate to the WorkoutDetailView.
   * - Appends the workout ID to the route path as a path parameter.
   *
   * Parameters:
   * - [context] (BuildContext): The BuildContext of the widget, used to perform navigation.
   * - [workout] (Workout): The selected workout object whose details are to be displayed.
   *
   * Example:
   * - If the workout has an ID of 1, this method navigates to the route '/exercise/1'.
   */
  void selectWorkout(BuildContext context, Workout workout) {
    String id = workout.id.toString(); 
    context.push('${ExerciseView.route}/${id}'); 
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Uh oh ... nothing here!'),
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
    }

    return NestedScaffold(
      appBar: AppBar(title: const Text('Exercise'), centerTitle: true),
      body: content,
    );
  }
}
