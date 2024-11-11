import 'package:fit_and_healthy/src/features/exercise/exercise_workout_card';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return ExerciseWorkoutCard(workout: workouts[index]);
        },
      ),
    );
  }
}
