import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

/**
 * The `ExerciseSelectionDialog` widget, provides a dialog
 * for selecting an exercise from a list of exercises. It includes:
 * - A scrollable list of exercises to choose from.
 * - Options to create a new exercise or cancel the selection.
 * - A callback function to pass the selected exercise back to the parent widget.
 */

class ExerciseSelectionDialog extends StatelessWidget {
  /**
   * Constructor for the `ExerciseSelectionDialog` widget.
   * 
   * @param exerciseInfoList A list of exercises available for selection.
   * @param onExerciseSelected A callback function triggered on exercise selection.
   */
  const ExerciseSelectionDialog({
    super.key,
    required this.exerciseInfoList,
    required this.onExerciseSelected,
  });

  final List<ExerciseInfoList> exerciseInfoList; //A list of exercises available for selection.

  /**
   * Callback function triggered when an exercise is selected.
   * 
   * @param onExerciseSelected A function that takes an `ExerciseInfoList` object or `null` if no exercise is selected.
   */
  final Function(ExerciseInfoList?) onExerciseSelected;



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Exercise'),
      content: SizedBox(
        width: double.maxFinite,
        /**
         * A scrollable list of exercises for selection.
         */
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: exerciseInfoList.length,
          itemBuilder: (context, index) {
            final exercise = exerciseInfoList[index];
            return ListTile(
              title: Text(exercise.name),
              onTap: () {
                Navigator.pop(context);
                onExerciseSelected(exercise); // Pass the selected exercise back
              },
            );
          },
        ),
      ),
      actions: [
         /**
         * Button to create a new exercise.
         * 
         * Closes the dialog and triggers the callback with a `null` value to indicate
         * that the user wants to create a new exercise.
         */
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onExerciseSelected(null); 
          },
          child: const Text('Create new exercise'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
