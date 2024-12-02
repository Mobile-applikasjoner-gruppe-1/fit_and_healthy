import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/widgets/exercise_workout_item.dart';
import 'package:go_router/go_router.dart';

/**
 * The ExerciseView widget displays a list of workouts, allowing users to view available
 * workout sessions or navigate to a detailed view of a selected workout.
 * 
 * Features:
 * - Displays a message if no workouts are available.
 * - Lists all workouts using ExerciseWorkoutItem widgets.
 * - Navigates to the WorkoutDetailView when a workout is selected.
 */
class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key, required this.workouts});

  static const route = '/exercise';
  static const routeName = 'Exercise';

  final List<Workout> workouts; // The list of workouts

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  late List<Workout> _workouts; // State to manage the dynamic workout list.

  @override
  void initState() {
    super.initState();
    _workouts = List.from(widget.workouts); 
    _sortWorkoutsByDate();
  }

    /**
   * Sorts the workouts by date in descending order (latest first).
   */
  void _sortWorkoutsByDate() {
    _workouts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /**
   * Navigates to the WorkoutDetailView for the selected workout.
   *
   * Functionality:
   * - Converts the workout's integer ID to a string, as GoRouter expects path parameters to be strings.
   * - Uses the GoRouter's `context.push` method to navigate to the WorkoutDetailView.
   * - Appends the workout ID to the route path as a path parameter.
   */
  void selectWorkout(BuildContext context, Workout workout) {
    String id = workout.id;
    context.push('${ExerciseView.route}/${id}', extra: _workouts,);
  }

  /**
   * Navigates to the Add Workout screen and waits for the result.
   * Adds the new workout to the list if one is returned.
   */
  Future<void> navigateToAddWorkout(BuildContext context) async {
    final newWorkout = await context.push<Workout?>('${ExerciseView.route}/add-workout');
    if (newWorkout != null) {
      setState(() {
        _workouts.add(newWorkout);
        _sortWorkoutsByDate(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loggedWorkouts;

    if (_workouts.isEmpty) {
      loggedWorkouts = const Text(
        'No workouts logged',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      );
    } else {
      loggedWorkouts = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _workouts.length,
        itemBuilder: (ctx, index) => ExerciseWorkoutItem(
          workout: _workouts[index],
          onSelectWorkout: (workout) {
            selectWorkout(context, workout);
          },
        ),
      );
    }

    Widget content = SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => navigateToAddWorkout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Add Workout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logged',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              loggedWorkouts,
            ],
          ),
        ),
      ),
    );

    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
