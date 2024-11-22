import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

/**
 * The AddExerciseView widget provides functionality for adding and managing
 * a new workout session.
 */
class AddExercise extends StatefulWidget {
  const AddExercise({super.key, required this.workouts});

  static const route = '/exercise/add-exercise';
  static const routeName = 'AddExercise';
  
  final List<Workout> workouts;

  @override
  State<AddExercise> createState() {
    return _AddExerciseState();
  }
}

  class _AddExerciseState extends State<AddExercise> {

  late final List<String> exerciseNames;

  @override
  void initState() {
    super.initState();
    exerciseNames = widget.workouts
        .expand((workout) => workout.exercises)
        .map((exercise) => exercise.exerciseInfoList.name)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Form(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  items: exerciseNames.map((name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  },).toList(),
                  onChanged: (value) {
                    print('Selected Exercise: $value');
                  },
                  decoration: const InputDecoration(
                    label: Text('Select Exercise'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an exercise';
                    }
                    return null;
                  },
                ),
                Expanded(child: 
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Note')
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

    return NestedScaffold(
      appBar: AppBar(
        title: Text('Add exercise'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // add exercise to workout
            },
            child: const Text(
              'Add exercise',
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
