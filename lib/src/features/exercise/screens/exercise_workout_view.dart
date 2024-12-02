import 'package:fit_and_healthy/src/features/exercise/exercise_date_notifier.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_add_workout.dart';
import 'package:fit_and_healthy/src/features/exercise/workout_list_controller.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/widgets/exercise_workout_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
              _buildDateSelector(context, ref, selectedDate),
              const SizedBox(height: 16),
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

  /**
   * Custom date picker.
   * Can go forwards or back a day, or press the center
   * to get a normal date picker.
   */
  Widget _buildDateSelector(
    BuildContext context,
    WidgetRef ref,
    DateTime? selectedDate,
  ) {
    final displayDate = selectedDate ?? DateTime.now();
    final dateFormat = DateFormat('d');
    final monthFormat = DateFormat('MMMM');
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: displayDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: theme.colorScheme.primary,
                  onPrimary: theme.colorScheme.onPrimary,
                  surface: theme.colorScheme.surface,
                  onSurface: theme.colorScheme.onSurface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          ref
              .read(exerciseDateNotifierProvider.notifier)
              .changeDate(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_left,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                final newDate = displayDate.subtract(const Duration(days: 1));
                ref
                    .read(exerciseDateNotifierProvider.notifier)
                    .changeDate(newDate);
              },
            ),
            Column(
              children: [
                Text(
                  dateFormat.format(displayDate),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  monthFormat.format(displayDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_right,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                final newDate = displayDate.add(const Duration(days: 1));
                ref
                    .read(exerciseDateNotifierProvider.notifier)
                    .changeDate(newDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
