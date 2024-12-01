import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/**
 * The `AddWorkout` widget provides a user interface 
 * for adding and managing a new workout session. It includes:
 * - A form for entering workout details (title, date, time).
 * - Buttons for navigating to add exercises and submitting the workout.
 * - The ability to select a date and time using pickers.
 */

class AddWorkout extends StatefulWidget {
  /**
   * Constructor for the `AddWorkout` widget.
   * 
   * @param workouts A list of `Workout` objects used to manage and display exercises in the workout session.
   */
  const AddWorkout({super.key, required this.workouts});

  static const route = '/exercise';
  static const routeName = 'Add Workout';

  final List<Workout> workouts; // The list of workouts

  @override
  State<AddWorkout> createState() {
    return _AddWorkoutState();
  }
}

class _AddWorkoutState extends State<AddWorkout> {
  String _title = 'New Workout'; // Default title of the workout
  DateTime _selectedDate = DateTime.now(); // Selected date
  TimeOfDay _selectedTime = TimeOfDay.now(); // Selected time
  List<Exercise> _exercises = []; // List of exercises added to the workout.

  /**
   * Navigates to the Add Exercise screen and waits for the result.
   * Updates the exercise list if a new exercise is added.
   * 
   * @param context The current BuildContext of the widget.
   */
  Future<void> _navigateToAddExercise(BuildContext context) async {
    final newExercise = await context.push<Exercise?>('${AddWorkout.route}/add-exercise');
    if (newExercise != null) {
      setState(() {
        _exercises.add(newExercise);
      });
    }
  }

  /**
   * Handles the date selection process using `showDatePicker`.
   * Updates the selected date if the user picks one.
   */
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /**
   * Handles the time selection process using `showTimePicker`.
   * Updates the selected time if the user picks one.
   */
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
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
                TextFormField(
                  decoration: const InputDecoration(label: Text('Title')),
                  initialValue: _title,
                  onChanged: (value) => setState(() {
                    _title = value;
                  }),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    await _selectDate(context);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        '${DateFormat.EEEE().format(_selectedDate)} ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _selectTime(context);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.access_alarms_outlined),
                      const SizedBox(width: 8),
                      Text(' ${_selectedTime.format(context)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _navigateToAddExercise(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
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
                if (_exercises.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _exercises[index];
                      return ListTile(
                        title: Text(exercise.exerciseInfoList.name),
                        subtitle: Text(
                          'Sets: ${exercise.sets.length} - Notes: ${exercise.note ?? 'None'}',
                        ),
                      );
                    },
                  )
                else
                  const Text('No exercises added yet.'),
              ],
            ),
          ),
        ),
      ),
    );

    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout added successfully!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
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
