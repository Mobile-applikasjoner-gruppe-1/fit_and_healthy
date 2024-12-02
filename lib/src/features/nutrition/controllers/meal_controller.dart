import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_controller.g.dart';

@riverpod
class MealController extends _$MealController {
  MealController();

  @override
  Future<void> build() async {}

  Future<String> addMeal(Meal meal) async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);
    final mealRepository = MealRepository(authRepository);

    return await mealRepository.addMeal(meal);
  }
}
