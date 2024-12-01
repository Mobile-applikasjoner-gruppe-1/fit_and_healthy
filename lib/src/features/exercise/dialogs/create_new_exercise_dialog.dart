import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

class CreateNewExerciseDialog extends StatefulWidget {
  final Function(ExerciseInfoList?) onCreateExercise;

  const CreateNewExerciseDialog({super.key, required this.onCreateExercise});

  @override
  State<CreateNewExerciseDialog> createState() => _CreateNewExerciseDialogState();
}

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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _createExercise,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
