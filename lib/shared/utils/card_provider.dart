import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_calories_nutrition.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_macro_nutritions.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weekly_workout.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weight.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_workout_history.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_data.dart';

import 'package:fit_and_healthy/shared/widgets/cards/nutrition_card_full.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO: Remove parameters in classes/methods, the card itself should handle fetching the data.

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
      workouts: sampleWorkouts,
    ),
  ),
];

final CardProvider = StateProvider<List<WidgetCard>>((ref) => []);
