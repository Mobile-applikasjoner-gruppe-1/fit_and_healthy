import 'package:fit_and_healthy/shared/models/exercise.dart';
import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_calories_nutrition.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_macro_nutritions.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weekly_workout.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weight.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_workout_history.dart';

import 'package:fit_and_healthy/shared/widgets/cards/nutrition_card_full.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final benchPress = ExerciseInfoList(
  id: 'e1',
  name: 'Bench Press',
  exerciseCategory: ExerciseCategory.chest,
  info: 'A compound exercise targeting the chest, shoulders, and triceps.',
);

final squat = ExerciseInfoList(
  id: 'e2',
  name: 'Squat',
  exerciseCategory: ExerciseCategory.legs,
  info: 'A compound exercise targeting the legs and core.',
);

final deadlift = ExerciseInfoList(
  id: 'e3',
  name: 'Deadlift',
  exerciseCategory: ExerciseCategory.back,
  info: 'A compound exercise targeting the back, hamstrings, and glutes.',
);

final shoulderPress = ExerciseInfoList(
  id: 'e4',
  name: 'Shoulder Press',
  exerciseCategory: ExerciseCategory.shoulders,
  info: 'A compound exercise targeting the shoulders and triceps.',
);

final List<Workout> exampleWorkouts = [
  Workout(
    id: 'w1',
    title: 'Upper Body Day',
    time: '1 hr',
    dateTime: DateTime.now().subtract(const Duration(days: 3)),
    exercises: [
      Exercise(
        id: '1',
        exerciseInfoList: benchPress,
        sets: [
          ExerciseSet(repititions: 10, weight: 80.0),
          ExerciseSet(repititions: 8, weight: 90.0),
          ExerciseSet(
              repititions: 6,
              weight: 100.0,
              exerciseSetType: ExerciseSetType.tofailure),
        ],
        note: 'Felt strong today.',
      ),
      Exercise(
        id: '2',
        exerciseInfoList: shoulderPress,
        sets: [
          ExerciseSet(repititions: 12, weight: 40.0),
          ExerciseSet(repititions: 10, weight: 45.0),
        ],
      ),
    ],
  ),
  Workout(
    id: 'w2',
    title: 'Lower Body Day',
    time: '1 hr 15 min',
    dateTime: DateTime.now().subtract(const Duration(days: 10)),
    exercises: [
      Exercise(
        id: '3',
        exerciseInfoList: squat,
        sets: [
          ExerciseSet(
              repititions: 12,
              weight: 100.0,
              exerciseSetType: ExerciseSetType.warmup),
          ExerciseSet(repititions: 10, weight: 120.0),
          ExerciseSet(
              repititions: 8,
              weight: 140.0,
              exerciseSetType: ExerciseSetType.tofailure),
        ],
        note: 'Pushed limits on depth.',
      ),
      Exercise(
        id: '4',
        exerciseInfoList: deadlift,
        sets: [
          ExerciseSet(repititions: 8, weight: 150.0),
          ExerciseSet(repititions: 6, weight: 160.0),
          ExerciseSet(
              repititions: 4,
              weight: 170.0,
              exerciseSetType: ExerciseSetType.tofailure),
        ],
      ),
    ],
  ),
  Workout(
    id: 'w3',
    title: 'Lower Body Day',
    time: '1 hr 15 min',
    dateTime: DateTime.now().subtract(const Duration(days: 11)),
    exercises: [
      Exercise(
        id: '3',
        exerciseInfoList: squat,
        sets: [
          ExerciseSet(
              repititions: 12,
              weight: 100.0,
              exerciseSetType: ExerciseSetType.warmup),
          ExerciseSet(repititions: 10, weight: 120.0),
          ExerciseSet(
              repititions: 8,
              weight: 140.0,
              exerciseSetType: ExerciseSetType.tofailure),
        ],
        note: 'Pushed limits on depth.',
      ),
      Exercise(
        id: '4',
        exerciseInfoList: deadlift,
        sets: [
          ExerciseSet(repititions: 8, weight: 150.0),
          ExerciseSet(repititions: 6, weight: 160.0),
          ExerciseSet(
              repititions: 4,
              weight: 170.0,
              exerciseSetType: ExerciseSetType.tofailure),
        ],
      ),
    ],
  ),
  Workout(
    id: 'w3',
    title: 'Full Body Day',
    time: '1 hr 30 min',
    dateTime: DateTime.now().subtract(const Duration(days: 15)),
    exercises: [
      Exercise(
        id: '5',
        exerciseInfoList: benchPress,
        sets: [
          ExerciseSet(repititions: 10, weight: 75.0),
          ExerciseSet(repititions: 8, weight: 85.0),
        ],
      ),
      Exercise(
        id: '6',
        exerciseInfoList: squat,
        sets: [
          ExerciseSet(
              repititions: 12,
              weight: 95.0,
              exerciseSetType: ExerciseSetType.warmup),
          ExerciseSet(repititions: 10, weight: 115.0),
        ],
      ),
      Exercise(
        id: '7',
        exerciseInfoList: deadlift,
        sets: [
          ExerciseSet(repititions: 8, weight: 140.0),
          ExerciseSet(repititions: 6, weight: 150.0),
        ],
      ),
    ],
  ),
];

final allCards = [
  WidgetCard(
    id: '3',
    title: 'Weight',
    size: 1.0,
    widgetCardCategory: WidgetCardCategory.measurament,
    builder: () => CardWeight(),
  ),
  WidgetCard(
    id: '4',
    title: 'Weight',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.measurament,
    builder: () => CardWeight(),
  ),
  WidgetCard(
    id: '5',
    title: 'WeeklyWorkout',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.workout,
    builder: () => CardWeeklyWorkout(),
  ),
  WidgetCard(
    id: '6',
    title: 'Nutrition',
    size: 1,
    widgetCardCategory: WidgetCardCategory.nutrition,
    builder: () => NutritionCard(
      caloriesConsumed: 1500,
      carbs: 100,
      carbsGoal: 150,
      fats: 100,
      fatsGoal: 150,
      proteins: 100,
      proteinsGoal: 150,
      totalCalories: 3000,
    ),
  ),
  WidgetCard(
    id: '7',
    title: 'Calories',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.nutrition,
    builder: () => CardCaloriesNutrition(
      caloriesConsumed: 1500,
    ),
  ),
  WidgetCard(
    id: '8',
    title: 'Macros',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.nutrition,
    builder: () => CardMacroNutritions(),
  ),
  WidgetCard(
    id: '9',
    title: 'Workout History',
    size: 1,
    widgetCardCategory: WidgetCardCategory.workout,
    builder: () => WorkoutHistoryCard(
      workouts: exampleWorkouts,
    ),
  ),
];

final CardProvider = StateProvider<List<WidgetCard>>((ref) => []);
