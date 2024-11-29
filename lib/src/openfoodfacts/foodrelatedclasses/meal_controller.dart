import 'mealHolderClass.dart';
import 'mealClass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'meal_controller.g.dart';

@riverpod
class MealController extends _$MealController {
  MealController();

  @override
  FutureOr<MealHolder> build() async {
    return MealHolder(date: DateTime.now());
  }

  /// Adds a meal to the MealHolder
  void addMeal(String name) async {
    final newMeal =
        Meal(name: name, timestamp: DateTime.now(), id: Uuid().v4());
    final previousState = await future;
    newMeal.addChangeNotifier(() {
      calculateTotalNutrition();
    });
    state = AsyncData(
        previousState.copyWith(meals: [...previousState.meals, newMeal]));
  }

  /// Removes a meal from the MealHolder by ID
  void removeMeal(String mealId) async {
    final previousState = await future;
    state = AsyncData(previousState.copyWith(
        meals: previousState.meals..removeWhere((meal) => meal.id == mealId)));
  }

  void calculateTotalNutrition() async {
    final previousState = await future;
    final newMealHolder = previousState.copyWith();
    newMealHolder.calculateTotalNutrition();
    state = AsyncData(newMealHolder);
  }
}
