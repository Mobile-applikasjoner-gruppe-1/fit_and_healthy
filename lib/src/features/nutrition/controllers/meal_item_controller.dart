import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_item_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_item_controller.g.dart';

@riverpod
class MealItemController extends _$MealItemController {
  MealItemController();

  @override
  Future<void> build() async {}

  Future<void> addFoodItemsToMeal(
      String mealId, List<FoodItem> foodItems) async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    final exerciseRepository = MealItemRepository(authRepository, mealId);

    await exerciseRepository.addFoodItems(foodItems);
  }
}
