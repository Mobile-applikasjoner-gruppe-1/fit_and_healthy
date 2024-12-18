import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/utils/dashboard_card_storage.dart';

import 'package:fit_and_healthy/shared/widgets/cards/card_calories_nutrition.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_macro_nutritions.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weekly_workout.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weight.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_workout_history.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_data.dart';

import 'package:fit_and_healthy/shared/widgets/cards/nutrition_card_full.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_workout_view.dart';
import 'package:fit_and_healthy/src/features/measurement/measurement_settings_page.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/screens/meal_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A list of all available widget cards to be displayed on the dashboard.
///
/// Each card is associated with a unique ID, size, category, widget builder,
/// and a route for detailed views.
final allCards = [
  WidgetCard(
    id: '3',
    title: 'Weight',
    size: 1.0,
    widgetCardCategory: WidgetCardCategory.measurament,
    builder: () => CardWeight(),
    route: MeasurementSettingsPage.routeName,
  ),
  WidgetCard(
    id: '4',
    title: 'Weight',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.measurament,
    builder: () => CardWeight(),
    route: MeasurementSettingsPage.routeName,
  ),
  WidgetCard(
    id: '5',
    title: 'WeeklyWorkout',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.workout,
    builder: () => CardWeeklyWorkout(),
    route: ExerciseView.routeName,
  ),
  WidgetCard(
    id: '6',
    title: 'Nutrition',
    size: 1,
    widgetCardCategory: WidgetCardCategory.nutrition,
    builder: () => NutritionCard(),
    route: MealListScreen.routeName,
  ),
  WidgetCard(
    id: '7',
    title: 'Calories',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.nutrition,
    builder: () => CardCaloriesNutrition(),
    route: MealListScreen.routeName,
  ),
  WidgetCard(
    id: '8',
    title: 'Macros',
    size: 0.5,
    widgetCardCategory: WidgetCardCategory.nutrition,
    builder: () => CardMacroNutritions(),
    route: MealListScreen.routeName,
  ),
  WidgetCard(
    id: '9',
    title: 'Workout History',
    size: 1,
    widgetCardCategory: WidgetCardCategory.workout,
    builder: () => WorkoutHistoryCard(
      workouts: sampleWorkouts,
    ),
    route: ExerciseView.routeName,
  ),
];

/// A provider for managing the state of selected widget cards on the dashboard.
final CardProvider =
    StateNotifierProvider<CardNotifier, List<WidgetCard>>((ref) {
  return CardNotifier(ref);
});

/// A [StateNotifier] that manages the list of selected widget cards.
///
/// Provides methods to load, save, and modify the selected cards.
class CardNotifier extends StateNotifier<List<WidgetCard>> {
  final Ref _ref;

  CardNotifier(this._ref) : super([]);

  Future<void> loadCards(List<WidgetCard> allCards) async {
    try {
      final savedCards = await DashboardCardStorage.loadSelectedCards(allCards);
      state = savedCards;
    } catch (e) {
      print("Error loading cards: $e");
      state = [];
    }
  }

  Future<void> saveState() async {
    try {
      await DashboardCardStorage.saveSelectedCards(state);
    } catch (e) {
      print("Error saving cards: $e");
    }
  }

  void addCard(WidgetCard card) {
    if (!state.contains(card)) {
      state = [...state, card];
      saveState();
    }
  }

  void removeCard(WidgetCard card) {
    state = state.where((c) => c.id != card.id).toList();
    saveState();
  }

  void setDefaultCards(List<String> defaultIds) {
    final allCards = _ref.read(allCardsProvider);
    final defaultCards =
        allCards.where((card) => defaultIds.contains(card.id)).toList();
    state = defaultCards;
    saveState();
  }
}

/// A provider that supplies the list of all available widget cards.
final allCardsProvider = Provider<List<WidgetCard>>((_) => allCards);
