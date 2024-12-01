import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

/**
 * The `CreateNewExerciseDialog` widget, provides a dialog
 * interface for creating a new exercise. It includes:
 * - Input fields for the exercise name, category, and information.
 * - Buttons to cancel the creation process or submit the new exercise.
 * - A callback function to pass the created exercise back to the parent widget.
 */

class CreateNewExerciseDialog extends StatefulWidget {
  /**
   * Constructor for the `CreateNewExerciseDialog` widget.
   * 
   * @param onCreateExercise A callback function triggered after the exercise creation.
   */
  const CreateNewExerciseDialog({super.key, required this.onCreateExercise});


  /**
   * Callback function triggered when a new exercise is created.
   * 
   * @param onCreateExercise A function that takes an `ExerciseInfoList` object or `null`.
   */
  final Function(ExerciseInfoList?) onCreateExercise;


  @override
  State<CreateNewExerciseDialog> createState() => _CreateNewExerciseDialogState();
}

/**
 * Validates the input fields and creates a new exercise.
 * 
 * If the required fields are filled out, the exercise is created and passed to
 * the parent widget via the `onCreateExercise` callback. Otherwise, an error
 * message is shown.
 */
class _CreateNewExerciseDialogState extends State<CreateNewExerciseDialog> {
  String? exerciseName;
  ExerciseCategory? exerciseCategory;
  String? exerciseInfo;

  void _createExercise() {
    if (exerciseName != null && exerciseCategory != null) {
      final newExercise = ExerciseInfoList(
        id: UniqueKey().toString(),
        name: exerciseName!,
        exerciseCategory: exerciseCategory!,
        info: exerciseInfo ?? '',
      );
      widget.onCreateExercise(newExercise);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Exercise'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Exercise Name'),
            onChanged: (value) {
              setState(() {
                exerciseName = value;
              });
            },
          ),
          /**
           * Dropdown menu for selecting the exercise category.
           * Updates the `exerciseCategory` variable when a category is selected.
           */
          DropdownButtonFormField<ExerciseCategory>(
            decoration: const InputDecoration(labelText: 'Category'),
            items: ExerciseCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                exerciseCategory = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Info'),
            onChanged: (value) {
              setState(() {
                exerciseInfo = value;
              });
            },
          ),
        ],
      ),
      actions: [
        /**
         * Button to cancel the exercise creation process.
         */
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        /**
         * Button to create the new exercise.
         * Validates the inputs and triggers the `_createExercise` method.
         */
        TextButton(
          onPressed: _createExercise,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
