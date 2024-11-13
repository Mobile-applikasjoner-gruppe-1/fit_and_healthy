import 'package:fit_and_healthy/src/features/exercise/exercise_workout_item.dart';
import 'package:flutter/material.dart';
import '../../../shared/models/exercise.dart';

class ExerciseView extends StatelessWidget {
  const ExerciseView({
    super.key,
    required this.workouts,
  });

  final List<Workout> workouts;

 @override
  Widget build(BuildContext context) {
    Widget content = Center(
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
          workout: workouts[index]
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

