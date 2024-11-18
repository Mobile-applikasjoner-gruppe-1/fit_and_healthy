import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_item.dart';

void main() {
  // Create a mock Exercise object for testing
  final mockExercise = Exercise(
    id: 1,
    exerciseInfoList: ExerciseInfoList(
      id: 1,
      name: 'Bench Press',
      exerciseCategory: ExerciseCategory.chest,
      info: 'A strength training exercise for chest muscles.',
    ),
    sets: [
      ExerciseSet(repititions: 10, weight: 50.0),
      ExerciseSet(repititions: 8, weight: 60.0, exerciseSetType: ExerciseSetType.dropset),
    ],
    note: 'Focus on form and breathing.',
  );

  group('ExerciseItem Widget Tests', () {
    testWidgets('displays exercise category, description, and sets', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseItem(exercise: mockExercise),
          ),
        ),
      );

      // Verify that the category is displayed correctly
      expect(find.text('Category: chest'), findsOneWidget);

      // Verify that the description is displayed correctly
      expect(find.text('A strength training exercise for chest muscles.'), findsOneWidget);

      // Verify that sets are displayed correctly
      expect(find.text('10 reps at 50.0 kg'), findsOneWidget);
      expect(find.text('8 reps at 60.0 kg (dropset)'), findsOneWidget);

      // Verify that the note is displayed correctly
      expect(find.text('Note: Focus on form and breathing.'), findsOneWidget);
    });

    testWidgets('hides note when it is null', (WidgetTester tester) async {
      // Create a mock Exercise object without a note
      final exerciseWithoutNote = Exercise(
        id: 2,
        exerciseInfoList: ExerciseInfoList(
          id: 2,
          name: 'Squat',
          exerciseCategory: ExerciseCategory.legs,
          info: 'A compound exercise targeting the lower body.',
        ),
        sets: [
          ExerciseSet(repititions: 12, weight: 80.0),
        ],
        note: null, // No note provided
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseItem(exercise: exerciseWithoutNote),
          ),
        ),
      );

      // Verify that the category and description are displayed correctly
      expect(find.text('Category: legs'), findsOneWidget);
      expect(find.text('A compound exercise targeting the lower body.'), findsOneWidget);

      // Verify that sets are displayed correctly
      expect(find.text('12 reps at 80.0 kg'), findsOneWidget);

      // Verify that the note is not displayed
      expect(find.textContaining('Note:'), findsNothing);
    });

    testWidgets('renders multiple sets correctly', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseItem(exercise: mockExercise),
          ),
        ),
      );

      // Verify that both sets are displayed
      expect(find.text('10 reps at 50.0 kg'), findsOneWidget);
      expect(find.text('8 reps at 60.0 kg (dropset)'), findsOneWidget);
    });

    testWidgets('renders correctly with an empty set list', (WidgetTester tester) async {
      // Create a mock Exercise object with no sets
      final exerciseWithNoSets = Exercise(
        id: 3,
        exerciseInfoList: ExerciseInfoList(
          id: 3,
          name: 'Deadlift',
          exerciseCategory: ExerciseCategory.back,
          info: 'A compound exercise for back strength.',
        ),
        sets: [], // No sets
        note: 'Lift with proper form.',
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseItem(exercise: exerciseWithNoSets),
          ),
        ),
      );

      // Verify that the category and description are displayed correctly
      expect(find.text('Category: back'), findsOneWidget);
      expect(find.text('A compound exercise for back strength.'), findsOneWidget);

      // Verify that no sets are displayed
      expect(find.textContaining('reps at'), findsNothing);

      // Verify that the note is displayed correctly
      expect(find.text('Note: Lift with proper form.'), findsOneWidget);
    });
  });
}
