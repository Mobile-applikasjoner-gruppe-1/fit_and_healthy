import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

/**
 * The AddWorkoutView widget provides functionality for adding and managing
 * a new workout session.
 * 
 * Features:
 * - Displays the total weight in the workout.
 * - Includes buttons for adding exercises or getting exercise suggestions.
 * - Contains a floating action button for additional options.
 */
class AddWorkoutView extends StatelessWidget {
  const AddWorkoutView({super.key});

  static const route = '/exercise';
  static const routeName = 'Exercise';

  void createWorkout(Workout workout) {
    // Create workout logic 
  }

   @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Center(
        child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: 
          Column(
            children:[
              ElevatedButton(
                onPressed: () => (),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Add Exercise', 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    return NestedScaffold(
      appBar: AppBar(
        title: Text('Add workout'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // creation of workout
            },
            child: const Text(
              'Finish',
              style: TextStyle(
                color: Colors.blue, 
              ),
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
