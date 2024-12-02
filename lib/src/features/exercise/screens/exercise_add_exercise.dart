import 'package:fit_and_healthy/src/features/exercise/exercise_data.dart';
import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/dialogs/exercise_selection_dialog.dart';
import 'package:fit_and_healthy/src/features/exercise/dialogs/create_new_exercise_dialog.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key, required this.workoutId});

  static const route = ':id/add-exercise';
  static const routeName = 'AddExercise';

  final String workoutId;

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final _formKey = GlobalKey<FormState>();
  ExerciseInfoList? selectedExercise;
  final List<Map<String, TextEditingController>> _setsControllers = [];
  String? note;

  @override
  void initState() {
    super.initState();
    _addSet(); // Add the first set by default.
  }

  @override
  void dispose() {
    for (var controllers in _setsControllers) {
      controllers['reps']?.dispose();
      controllers['weight']?.dispose();
    }
    super.dispose();
  }

  Future<void> _showExerciseSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return ExerciseSelectionDialog(
          exerciseInfoList: sampleExerciseInfoList,
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

  void _addSet() {
    setState(() {
      _setsControllers.add({
        'reps': TextEditingController(),
        'weight': TextEditingController(),
      });
    });
  }

  void _removeSet(int index) {
    setState(() {
      _setsControllers[index]['reps']?.dispose();
      _setsControllers[index]['weight']?.dispose();
      _setsControllers.removeAt(index);
    });
  }

  bool _validateSets() {
    bool isValid = true;

    for (var controllers in _setsControllers) {
      final reps = int.tryParse(controllers['reps']?.text ?? '');
      final weight = double.tryParse(controllers['weight']?.text ?? '');

      if (reps == null || reps <= 0 || weight == null || weight <= 0) {
        isValid = false;
      }
    }

    return isValid;
  }

  Exercise _createExercise() {
    final exerciseSets = _setsControllers.map((controllers) {
      return ExerciseSet(
        repititions: int.tryParse(controllers['reps']?.text ?? '0') ?? 0,
        weight: double.tryParse(controllers['weight']?.text ?? '0.0') ?? 0.0,
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
        child: Form(
          key: _formKey,
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
                itemCount: _setsControllers.length,
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
                          controller: _setsControllers[index]['reps'],
                          decoration: InputDecoration(
                            labelText: 'Reps',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final reps = int.tryParse(value ?? '');
                            if (reps == null || reps <= 0) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: _setsControllers[index]['weight'],
                          decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final weight = double.tryParse(value ?? '');
                            if (weight == null || weight <= 0) {
                              return 'Invalid';
                            }
                            return null;
                          },
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
              if (selectedExercise == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No exercise selected.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_formKey.currentState!.validate()) {
                final createdExercise = _createExercise();
                if (mounted) {
                  Navigator.pop(context, createdExercise);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Must be a positive number.'),
                    backgroundColor: Colors.red,
                  ),
                );
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
