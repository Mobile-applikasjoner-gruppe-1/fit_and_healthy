import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/**
 * The `AddWorkout` widget, provides a user interface 
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

  /**
   * Navigates to the Add Exercise screen using `GoRouter` to 
   * navigate to the add-exercise route.
   * 
   * @param context The current BuildContext of the widget.
   */
  void _navigateToAddExercise(BuildContext context) {
    context.push('${AddWorkout.route}/add-exercise');
  }

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Add workout'),
        centerTitle: true,
        actions: [
          /**
           * Finalizes the workout creation process.
           * 
           * Displays a success message and navigates back to the previous screen.
           */
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
      body: SingleChildScrollView(
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
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text('${DateFormat.EEEE().format(_selectedDate)} ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',)
                      ]
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.access_alarms_outlined),
                        const SizedBox(width: 8),
                        Text(' ${_selectedTime.format(context)}',),
                      ],
                    )
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
                  // Display the list of exercises here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}