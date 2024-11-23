import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mealHolderClass.dart';
import 'mealClass.dart';

class MealNotifier extends StateNotifier<MealHolder> {
  MealNotifier() : super(MealHolder(date: DateTime.now()));

  /// Adds a meal to the MealHolder
  void addMeal(String name) {
    final newMeal = Meal(name: name);
    state.addMeal(newMeal);
    _updateState();
  }

  /// Removes a meal from the MealHolder by ID
  void removeMeal(String mealId) {
    state.removeMeal(mealId);
    _updateState();
  }

  /// Calculates total nutrition values for all meals
  Map<String, double> calculateTotalNutrition() {
    return state.calculateTotalNutrition();
  }

  /// Internal method to trigger a state update
  void _updateState() {
    state = MealHolder(date: state.date)..meals.addAll(state.meals);
  }
}

/// Riverpod provider for MealNotifier
final mealNotifierProvider =
    StateNotifierProvider<MealNotifier, MealHolder>((ref) => MealNotifier());
