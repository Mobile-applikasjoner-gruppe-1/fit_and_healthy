import 'package:fit_and_healthy/shared/models/exercise.dart';

const List<ExerciseInfoList> sampleExerciseInfoList = [
  ExerciseInfoList(
    name: 'Bench Press',
    exerciseCategory: ExerciseCategory.chest,
    info: 'A classic chest exercise for building upper body strength.',
  ),
  ExerciseInfoList(
    name: 'Deadlift',
    exerciseCategory: ExerciseCategory.back,
    info: 'A compound exercise targeting back, legs, and core.',
  ),
  ExerciseInfoList(
    name: 'Squat',
    exerciseCategory: ExerciseCategory.legs,
    info: 'A key lower body exercise for building leg strength.',
  ),
  ExerciseInfoList(
    name: 'Shoulder Press',
    exerciseCategory: ExerciseCategory.shoulders,
    info: 'Targets shoulder muscles, enhancing upper body strength.',
  ),
  ExerciseInfoList(
    name: 'Bicep Curl',
    exerciseCategory: ExerciseCategory.biceps,
    info: 'An isolation exercise for strengthening the biceps.',
  ),
];

const List<ExerciseSet> sampleExerciseSets = [
  ExerciseSet(
      repititions: 10, weight: 50.0, exerciseSetType: ExerciseSetType.warmup),
  ExerciseSet(
      repititions: 8, weight: 75.0, exerciseSetType: ExerciseSetType.dropset),
  ExerciseSet(
      repititions: 6,
      weight: 100.0,
      exerciseSetType: ExerciseSetType.tofailure),
];

const List<Exercise> sampleExercises = [
  Exercise(
    id: '1',
    exerciseInfoList: ExerciseInfoList(
      name: 'Bench Press',
      exerciseCategory: ExerciseCategory.chest,
      info: 'A classic chest exercise for building upper body strength.',
    ),
    sets: [
      ExerciseSet(repititions: 10, weight: 50.0),
      ExerciseSet(repititions: 8, weight: 55.0),
      ExerciseSet(
          repititions: 6,
          weight: 60.0,
          exerciseSetType: ExerciseSetType.tofailure),
    ],
    note: 'Focus on controlled movement to activate chest muscles.',
  ),
  Exercise(
    id: '2',
    exerciseInfoList: ExerciseInfoList(
      name: 'Deadlift',
      exerciseCategory: ExerciseCategory.back,
      info: 'A compound exercise targeting back, legs, and core.',
    ),
    sets: [
      ExerciseSet(repititions: 10, weight: 70.0),
      ExerciseSet(repititions: 8, weight: 80.0),
      ExerciseSet(
          repititions: 5,
          weight: 90.0,
          exerciseSetType: ExerciseSetType.dropset),
    ],
    note: 'Keep back straight to avoid injury.',
  ),
  Exercise(
    id: '3',
    exerciseInfoList: ExerciseInfoList(
      name: 'Squat',
      exerciseCategory: ExerciseCategory.legs,
      info: 'A key lower body exercise for building leg strength.',
    ),
    sets: [
      ExerciseSet(repititions: 12, weight: 40.0),
      ExerciseSet(repititions: 10, weight: 50.0),
      ExerciseSet(
          repititions: 8,
          weight: 60.0,
          exerciseSetType: ExerciseSetType.warmup),
    ],
    note: 'Engage core during the squat.',
  ),
];

final List<Workout> emptyWorkouts = [];

final List<Workout> sampleWorkouts = [
  Workout(
    id: '1',
    title: 'Chest & Back Day',
    dateTime: DateTime.now(),
    exercises: [
      sampleExercises[0],
      sampleExercises[1],
    ],
  ),
  Workout(
    id: '2',
    title: 'Leg Day',
    dateTime: DateTime.now().add(Duration(days: 1)),
    exercises: [
      sampleExercises[2],
    ],
  ),
  Workout(
    id: '3',
    title: 'Upper Body Strength',
    dateTime: DateTime.now().add(Duration(days: 2)),
    exercises: [
      sampleExercises[0],
      sampleExercises[2],
    ],
  ),
];
