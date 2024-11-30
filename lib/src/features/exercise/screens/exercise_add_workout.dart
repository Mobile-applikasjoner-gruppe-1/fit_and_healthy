import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/**
 * The AddWorkoutView widget provides functionality for adding and managing
 * a new workout session.
 * 
 * Features:
 * - Displays the total weight in the workout.
 * - Includes buttons for adding exercises or getting exercise suggestions.
 * - Contains a floating action button for additional options.
 */
class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key, required this.workouts});

  static const route = '/exercise';

  final List<Workout> workouts;

  @override
  State<AddWorkout> createState() {
    return _AddWorkoutState();
  }
}

class _AddWorkoutState extends State<AddWorkout> {

  /**
   * Navigates to the Add Exercise screen for a spesific workout with id.
   */
  void navigateToAddExercise(BuildContext context) {
    //context.push('${AddWorkout.route}/add-exercise/${id}');
  }

  List<Exercise> getExercisesFromWorkout(Workout workout) {
    return workout.exercises;
  }
  void createWorkout(Workout workout) {
    // Create workout logic when pressed 'finished'
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


    Widget content = SingleChildScrollView(
      child: Center(
        child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Form(
          child: Column(
            children: [
              Column(
                children:[
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Date')
                    ),
                    initialValue: _formatDate(DateTime.now()),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Time')
                    ),
                    initialValue: TimeOfDay.fromDateTime(DateTime.now()).toString(),
                  ),
                  DropdownButtonFormField<ExerciseCategory>(
                    items: [
                      for (final category in ExerciseCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(category.name),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      print('Selected Category: $value');
                    },
                    decoration: const InputDecoration(
                      label: Text('Select Category'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => {
                      navigateToAddExercise(context),
                    },
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

                  // Add list of all exercises within this workout
                ],
              ),
            ],
          ))
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
              // createWorkout(newWorkout)
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
