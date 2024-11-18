import 'package:flutter_test/flutter_test.dart';
import 'package:fit_and_healthy/shared/models/exercise.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExerciseInfoList', () {
    test('ExerciseInfoList should be instantiated correctly', () {
      final exerciseInfo = ExerciseInfoList(
        id: 1,
        name: 'Bench Press',
        exerciseCategory: ExerciseCategory.chest,
        info: 'A strength training exercise for chest muscles.',
      );

      try {
        expect(exerciseInfo.id, 1);
        expect(exerciseInfo.name, 'Bench Press');
        expect(exerciseInfo.exerciseCategory, ExerciseCategory.chest);
        expect(exerciseInfo.info, 'A strength training exercise for chest muscles.');
        print('PASS: ExerciseInfoList instantiated correctly.');
      } catch (e) {
        print('FAIL: ExerciseInfoList failed with error: $e');
        rethrow;
      }
    });
  });

  group('ExerciseSet', () {
    test('ExerciseSet should handle optional set type', () {
      final set = ExerciseSet(
        repititions: 10,
        weight: 50.0,
      );

      try {
        expect(set.repititions, 10);
        expect(set.weight, 50.0);
        expect(set.exerciseSetType, isNull);
        print('PASS: ExerciseSet handles optional set type.');
      } catch (e) {
        print('FAIL: ExerciseSet failed with error: $e');
        rethrow;
      }
    });

    test('ExerciseSet should handle special set types', () {
      final set = ExerciseSet(
        repititions: 8,
        weight: 40.0,
        exerciseSetType: ExerciseSetType.dropset,
      );

      try {
        expect(set.repititions, 8);
        expect(set.weight, 40.0);
        expect(set.exerciseSetType, ExerciseSetType.dropset);
        print('PASS: ExerciseSet handles special set types.');
      } catch (e) {
        print('FAIL: ExerciseSet failed with error: $e');
        rethrow;
      }
    });
  });

  group('Exercise', () {
    test('Exercise should link ExerciseInfoList and sets correctly', () {
      final exerciseInfo = ExerciseInfoList(
        id: 2,
        name: 'Squat',
        exerciseCategory: ExerciseCategory.legs,
        info: 'A compound exercise targeting the lower body.',
      );

      final exercise = Exercise(
        id: 101,
        exerciseInfoList: exerciseInfo,
        sets: [
          ExerciseSet(repititions: 12, weight: 60.0),
          ExerciseSet(repititions: 10, weight: 70.0, exerciseSetType: ExerciseSetType.warmup),
        ],
        note: 'Focus on form',
      );

      try {
        expect(exercise.id, 101);
        expect(exercise.exerciseInfoList.name, 'Squat');
        expect(exercise.sets.length, 2);
        expect(exercise.note, 'Focus on form');
        print('PASS: Exercise links ExerciseInfoList and sets correctly.');
      } catch (e) {
        print('FAIL: Exercise failed with error: $e');
        rethrow;
      }
    });
  });

  group('Workout', () {
    test('Workout should handle multiple exercises', () {
      final exercise1 = Exercise(
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
      );

      final exercise2 = Exercise(
        id: 2,
        exerciseInfoList: ExerciseInfoList(
          id: 2,
          name: 'Squat',
          exerciseCategory: ExerciseCategory.legs,
          info: 'A compound exercise targeting the lower body.',
        ),
        sets: [
          ExerciseSet(repititions: 12, weight: 60.0),
        ],
      );

      final workout = Workout(
        id: 1,
        title: 'Leg Day',
        time: '1 hour',
        dateTime: DateTime.parse('2024-11-18'),
        exercises: [exercise1, exercise2],
      );

      try {
        expect(workout.id, 1);
        expect(workout.title, 'Leg Day');
        expect(workout.time, '1 hour');
        expect(workout.dateTime, DateTime.parse('2024-11-18'));
        expect(workout.exercises.length, 2);
        print('PASS: Workout handles multiple exercises.');
      } catch (e) {
        print('FAIL: Workout failed with error: $e');
        rethrow;
      }
    });
  });
}
