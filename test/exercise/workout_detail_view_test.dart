import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_item.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_workout_detail.dart';

void main() {
  // Mock data
  final mockWorkoutWithExercises = Workout(
    id: 1,
    title: 'Upper Body Day',
    time: '1 hour',
    dateTime: DateTime(2024, 11, 13),
    exercises: [
      Exercise(
        id: 1,
        exerciseInfoList: ExerciseInfoList(
          id: 1,
          name: 'Bench Press',
          exerciseCategory: ExerciseCategory.chest,
          info: 'A strength training exercise for chest muscles.',
        ),
        sets: [
          ExerciseSet(repititions: 10, weight: 50.0),
        ],
        note: 'Keep elbows at 45 degrees.',
      ),
      Exercise(
        id: 2,
        exerciseInfoList: ExerciseInfoList(
          id: 2,
          name: 'Pull-Up',
          exerciseCategory: ExerciseCategory.back,
          info: 'Bodyweight exercise for the back.',
        ),
        sets: [
          ExerciseSet(repititions: 12, weight: 0.0),
        ],
      ),
    ],
  );

  final mockWorkoutWithoutExercises = Workout(
    id: 2,
    title: 'Empty Workout',
    time: '30 minutes',
    dateTime: DateTime(2024, 11, 14),
    exercises: [],
  );

  group('WorkoutDetailView Widget Tests', () {
    testWidgets('displays workout title and date correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutDetailView(workout: mockWorkoutWithExercises),
        ),
      );

      // Verify the workout title is displayed in the AppBar
      expect(find.text('Upper Body Day'), findsOneWidget);

      // Verify the workout date is formatted and displayed correctly
      expect(find.text('Workout Date: November 13, 2024'), findsOneWidget);
    });

    testWidgets('displays "No exercises available" when there are no exercises', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutDetailView(workout: mockWorkoutWithoutExercises),
        ),
      );

      // Verify that "No exercises available" message is displayed
      expect(find.text('No exercises available'), findsOneWidget);

      // Verify that no ExerciseItem widgets are displayed
      expect(find.byType(ExerciseItem), findsNothing);
    });

    testWidgets('renders NestedScaffold and AppBar correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutDetailView(workout: mockWorkoutWithExercises),
        ),
      );

      // Verify that NestedScaffold is used
      expect(find.byType(NestedScaffold), findsOneWidget);

      // Verify that AppBar is displayed with the correct title
      expect(find.text('Upper Body Day'), findsOneWidget);
    });
  });
}
