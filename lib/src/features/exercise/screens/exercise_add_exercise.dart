import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/dialogs/exercise_selection_dialog.dart';
import 'package:fit_and_healthy/src/features/exercise/dialogs/create_new_exercise_dialog.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';

/**
 * The `AddExercise` widget provides a user interface
 * for selecting or creating a new exercise, adding sets, and optional notes.
 * It includes:
 * - A dialog for selecting or creating an exercise.
 * - Input fields for sets (reps, weight).
 * - Constructs an `Exercise` object based on the user inputs.
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

  final List<ExerciseInfoList> exerciseInfoList; // List of available exercises.

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  ExerciseInfoList? selectedExercise; // The selected exercise.
  List<Map<String, String>> sets = [{'reps': '', 'weight': ''}]; // List of sets (reps, weight).
  String? note; // Optional note for the exercise.

  /**
   * Displays the dialog for selecting an exercise.
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

  /**
   * Adds a new set to the list of sets.
   */
  void _addSet() {
    setState(() {
      sets.add({'reps': '', 'weight': ''});
    });
  }

  /**
   * Removes a set from the list based on its index.
   * 
   * @param index The index of the set to be removed.
   */
  void _removeSet(int index) {
    setState(() {
      sets.removeAt(index);
    });
  }

  /**
   * Constructs an `Exercise` object from the selected exercise, sets, and note.
   */
  Exercise _createExercise() {
    final exerciseSets = sets.map((set) {
      return ExerciseSet(
        repititions: int.tryParse(set['reps'] ?? '0') ?? 0,
        weight: double.tryParse(set['weight'] ?? '0.0') ?? 0.0,
      );
    }).toList();

    return Exercise(
      id: UniqueKey().toString(),
      exerciseInfoList: selectedExercise!,
      sets: exerciseSets,
      note: note,
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
                    fontSize: 20,
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
            const SizedBox(height: 8),
            Text(
              selectedExercise!.info,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Add Note (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => note = value,
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Sets',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: sets.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => sets[index]['reps'] = value,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => sets[index]['weight'] = value,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeSet(index),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _addSet,
                child: const Text('Add Set'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
            )
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
                if (mounted) {
                  final createdExercise = _createExercise();
                  Navigator.pop(context, createdExercise);
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an exercise first.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
