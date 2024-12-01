import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

class ExerciseSelectionDialog extends StatelessWidget {
  final List<ExerciseInfoList> exerciseInfoList;
  final Function(ExerciseInfoList?) onExerciseSelected;

  const ExerciseSelectionDialog({
    super.key,
    required this.exerciseInfoList,
    required this.onExerciseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Exercise'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: exerciseInfoList.length,
          itemBuilder: (context, index) {
            final exercise = exerciseInfoList[index];
            return ListTile(
              title: Text(exercise.name),
              onTap: () {
                Navigator.pop(context);
                onExerciseSelected(exercise);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onExerciseSelected(null); // Triggers 'Create New Exercise' in parent
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
