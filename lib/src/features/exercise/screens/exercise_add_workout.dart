import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/**
 * The AddWorkoutView widget provides functionality for adding and managing
 * a new workout session.
 * 
 * Features:
 * - Displays the total weight in the workout.
 * - Includes buttons for adding exercises or getting exercise suggestions.
 * - Contains a floating action button for additional options.
 */
class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key, required this.workouts});

  static const route = '/exercise';

  final List<Workout> workouts;

  @override
  State<AddWorkout> createState() {
    return _AddWorkoutState();
  }
}

class _AddWorkoutState extends State<AddWorkout> {
  String _title = 'New Workout';
  DateTime _selectedDate = DateTime.now(); 
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<Exercise> _exercises = [];
  
  /**
   * Opens the date picker dialog and updates the selected date.
   */
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Update the selected date
      });
    }
  }

  /**
   * Opens the time picker dialog and updates the selected time.
   */
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime; // Update the selected time
      });
    }
  }

  void navigateToAddExercise(BuildContext context) {
    context.push('${AddWorkout.route}/add-exercise');
  }

  List<Exercise> getExercisesFromWorkout(Workout workout) {
    return workout.exercises;
  }

  void _createWorkout() {
    final newWorkout = Workout(
      id: UniqueKey().toString(),
      title: _title,
      time: _formatTime(_selectedTime),
      dateTime: _selectedDate,
      exercises: _exercises,
    );
  }

  /**
   * The formatDate method, format the date as 'MMM d, yyyy'. 
   * This could be for example, 'November 13, 2024'
   */
  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final timeAsDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(timeAsDateTime);
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
              Column(
                children:[
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Title')
                    ),
                    initialValue: 'New workout',
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text('Date'),
                        ),
                        controller: TextEditingController(
                          text: _formatDate(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(label: Text('Time')),
                        controller: TextEditingController(
                          text: _formatTime(_selectedTime),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => {
                      navigateToAddExercise(context),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
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

                  // Add list of all exercises within this workout
                ],
              ),
            ],
          ))
        ),
      ),
    );

    return NestedScaffold(
      appBar: AppBar(
        title: Text('Add workout'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              //_createWorkout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Workout added successfully!'),
                  duration: const Duration(seconds: 2),
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
