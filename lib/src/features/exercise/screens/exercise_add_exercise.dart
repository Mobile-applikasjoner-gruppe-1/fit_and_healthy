import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/dialogs/exercise_selection_dialog.dart';
import 'package:fit_and_healthy/src/features/exercise/dialogs/create_new_exercise_dialog.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

/**
 * The `AddExercise` widget provides a user interface
 * for selecting or creating a new exercise. It includes:
 * - A dialog for selecting an existing exercise.
 * - A dialog for creating a new exercise if none exists or is selected.
 * - Displays details of the selected exercise.
 */
class AddExercise extends StatefulWidget {
  /**
   * Constructor for the `AddExercise` widget.
   * 
   * @param exerciseInfoList A list of `ExerciseInfoList` objects for displaying
   * the available exercises to choose from.
   */
  const AddExercise({super.key, required this.exerciseInfoList});

  static const route = '/exercise';
  static const routeName = 'Add Exercise';

  final List<ExerciseInfoList> exerciseInfoList; // List of exercises info

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  ExerciseInfoList? selectedExercise;

  @override
  void initState() {
    /**
     * Displays the exercise selection dialog when the widget is first built.
     * This ensures the user interacts with the dialog immediately on screen load.
     */
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showExerciseSelectionDialog();
    });
  }

  /**
   * Displays the dialog for selecting an exercise.
   * 
   * If an exercise is selected, updates the `selectedExercise`. If the user
   * chooses to create a new exercise, opens the `CreateNewExerciseDialog`.
   */
  Future<void> _showExerciseSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return ExerciseSelectionDialog(
          exerciseInfoList: widget.exerciseInfoList,
          onExerciseSelected: (exercise) {
            if (exercise == null) {
              _showCreateNewExerciseDialog();
            } else {
              setState(() {
                selectedExercise = exercise;
              });
            }
          },
        );
      },
    );
  }

  /**
   * Displays the dialog for creating a new exercise.
   * 
   * If a new exercise is created, updates the `selectedExercise` to reflect the new value.
   */
  Future<void> _showCreateNewExerciseDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateNewExerciseDialog(
          onCreateExercise: (newExercise) {
            if (newExercise != null) {
              setState(() {
                selectedExercise = newExercise;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget exerciseContent;

    if (selectedExercise == null) {
      exerciseContent = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No exercise selected. Please select an exercise.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: _showExerciseSelectionDialog,
                  tooltip: 'Edit Exercise',
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    await _showExerciseSelectionDialog();
                  },
                  child: const Text('Select exercise'),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      exerciseContent = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedExercise!.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: _showExerciseSelectionDialog,
                  tooltip: 'Edit Exercise',
                ),
              ],
            ),
            Text(
              selectedExercise!.exerciseCategory.name,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              selectedExercise!.info,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    Widget content = SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: exerciseContent,
        ),
      ),
    );

    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (selectedExercise != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exercise added successfully!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an exercise first.'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Add exercise',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
