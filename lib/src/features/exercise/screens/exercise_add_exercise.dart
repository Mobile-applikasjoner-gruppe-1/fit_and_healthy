import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

/**
 * The AddExerciseView widget provides functionality for adding and managing
 * a new workout session.
 */
class AddExercise extends StatefulWidget {
  const AddExercise({super.key, required this.exerciseInfoList});

  static const route = '/exercise';

  final List<ExerciseInfoList> exerciseInfoList;

  @override
  State<AddExercise> createState() {
    return _AddExerciseState();
  }
}

class _AddExerciseState extends State<AddExercise> {
  ExerciseInfoList? selectedExercise;

  @override
  void initState() {
    super.initState();
    // Show the selection dialog as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showExerciseSelectionDialog();
    });
  }

  /**
   * Opens a dialog to allow the user to select an exercise.
   * 
   * If the user selects an exercise, it updates the [selectedExercise].
   */
  Future<void> _showExerciseSelectionDialog() async {
    final exercise = await showDialog<ExerciseInfoList>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Exercise'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.exerciseInfoList.length,
              itemBuilder: (context, index) {
                final exercise = widget.exerciseInfoList[index];
                return ListTile(
                  title: Text(exercise.name),
                  onTap: () {
                    Navigator.pop(context, exercise);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                _showCreateNewExerciseDialog(); 
              },
              child: const Text('Create new exercise'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (exercise != null) {
      setState(() {
        selectedExercise = exercise;
      });
    }
  }


  Future<void> _showCreateNewExerciseDialog() async {
    String? exerciseName;
    ExerciseCategory? exerciseCategory;
    String? exerciseInfo;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                onChanged: (value) {
                  exerciseName = value;
                },
              ),
              DropdownButtonFormField<ExerciseCategory>(
                decoration: const InputDecoration(labelText: 'Category'),
                items: ExerciseCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  exerciseCategory = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Note'),
                onChanged: (value) {
                  exerciseInfo = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (exerciseName != null && exerciseCategory != null) {
                  setState(() {
                    selectedExercise = ExerciseInfoList(
                      id: UniqueKey().toString(),
                      name: exerciseName!,
                      exerciseCategory: exerciseCategory!,
                      info: exerciseInfo ?? '',
                    );
                  });

                  Navigator.pop(context); // Close only the Create Exercise dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out all fields'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  /**
   * Adds the selected exercise to the workout.
   * Displays a success message using a SnackBar.
   */
  void _addExerciseToWorkout() {
    if (selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an exercise first.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('Exercise added to workout: ${selectedExercise!.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise added successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (selectedExercise == null) {
      content = const Center(
        child: Text(
          'Oh no! Please select an exercise.',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${selectedExercise!.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showExerciseSelectionDialog();
                  },
                  tooltip: 'Edit Exercise',
                ),
              ],
            ),
            Text(
              '${selectedExercise!.exerciseCategory}',
              style: const TextStyle(fontSize: 12,),
            ),
            Text(
              '${selectedExercise!.info}',
              style: const TextStyle(fontSize: 12,),
            ),
          ],
        )
      );
    }

    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _addExerciseToWorkout,
            child: const Text(
              '+',
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
