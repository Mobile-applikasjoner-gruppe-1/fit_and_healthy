import 'package:fit_and_healthy/src/features/exercise/exercise_date_notifier.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_add_workout.dart';
import 'package:fit_and_healthy/src/features/exercise/workout_list_controller.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/widgets/exercise_workout_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
class ExerciseView extends ConsumerWidget {
  const ExerciseView({super.key});

  static const route = '/exercise';
  static const routeName = 'Exercise';

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
    context.push('${ExerciseView.route}/${id}');
  }

  /**
   * Navigates to the Add Workout screen and waits for the result.
   * Adds the new workout to the list if one is returned.
   */
  Future<void> navigateToAddWorkout(BuildContext context) async {
    await context.pushNamed(AddWorkout.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget loggedWorkouts;

    final exerciseDate = ref.watch(exerciseDateNotifierProvider);
    final workoutListState = ref.watch(workoutNotifierProvider);

    DateTime? selectedDate;

    if (exerciseDate is AsyncLoading) {
      loggedWorkouts = const Center(child: CircularProgressIndicator());
    } else if (exerciseDate is AsyncError) {
      loggedWorkouts = Center(child: Text('Error: ${exerciseDate.error}'));
    } else {
      selectedDate = exerciseDate.value;
      if (selectedDate == null) {
        loggedWorkouts = const Center(child: CircularProgressIndicator());
      } else {
        final workoutNotifier = ref.read(workoutNotifierProvider.notifier);
        workoutNotifier.listenToDate(selectedDate);
      }
    }

    if (workoutListState is AsyncLoading) {
      loggedWorkouts = const Center(child: CircularProgressIndicator());
    } else if (workoutListState is AsyncError) {
      loggedWorkouts = Center(child: Text('Error: ${workoutListState.error}'));
    } else {
      if (workoutListState.value == null) {
        loggedWorkouts = const Center(child: CircularProgressIndicator());
      }

      final workouts = workoutListState.value!.cachedDateWorkouts[selectedDate];

      if (workouts == null || workouts.isEmpty) {
        loggedWorkouts = const Text(
          'No workouts logged',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        );
      } else {
        loggedWorkouts = ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          itemBuilder: (ctx, index) => ExerciseWorkoutItem(
            workout: workouts[index],
            onSelectWorkout: (workout) {
              selectWorkout(context, workout);
            },
          ),
        );
      }
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
                child: Text(
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
