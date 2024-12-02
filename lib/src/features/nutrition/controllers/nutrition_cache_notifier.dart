import 'dart:async';

import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_item_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/data/meal_repository.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nutrition_cache_notifier.g.dart';

@Riverpod(keepAlive: true)
class NutritionCacheNotifier extends _$NutritionCacheNotifier {
  late final FirebaseAuthRepository _authRepository;
  late final MealRepository _mealRepository;

  Map<DateTime, StreamSubscription<List<Meal>>> _dateMealsStreamSubscriptions =
      {};
  Map<DateTime, Stream<List<Meal>>> _dateMealsStreams = {};
  Map<String, StreamSubscription<List<FoodItem>>>
      _mealFoodItemsStreamSubscriptions = {};
  Map<String, Stream<List<FoodItem>>> _mealFoodItemsStreams = {};
  Map<DateTime, bool> _datesWithFoodItemListeners = {};

  @override
  Future<NutritionCacheState> build() async {
    _authRepository = ref.read(firebaseAuthRepositoryProvider);
    _mealRepository = MealRepository(_authRepository);

    return NutritionCacheState(
      cachedDateMeals: {},
      cachedMeals: {},
      cachedMealFoodItems: {},
    );
  }

  DateTime _dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  _foodItemsStreamCallback(
      List<FoodItem> foodItems, DateTime normalizedMealDate, String mealId) {
    state.when(
      data: (data) {
        Meal? meal;
        final mealsForDate = data.cachedDateMeals[normalizedMealDate] ?? [];
        final List<Meal> updatedMealsForDate = [];
        for (final m in mealsForDate) {
          if (m.id == mealId) {
            m.items = foodItems;
            updatedMealsForDate.add(m);
            meal = m;
          } else {
            updatedMealsForDate.add(m);
          }
        }

        state = AsyncValue.data(data.copyWith(
          cachedMealFoodItems: {
            ...data.cachedMealFoodItems,
            mealId: foodItems,
          },
          cachedDateMeals: {
            ...data.cachedDateMeals,
            normalizedMealDate: updatedMealsForDate,
          },
          cachedMeals: meal != null
              ? {
                  ...data.cachedMeals,
                  mealId: meal,
                }
              : null,
        ));
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  _mealsStreamCallback(
      List<Meal> meals, DateTime normalizedDate, bool listenToFoodItems) {
    state.when(
      data: (data) {
        // Update cached meals by adding them to a map indexed by meal id
        final updatedCachedMeals = {
          ...data.cachedMeals,
          for (final meal in meals) meal.id: meal,
        };
        final updatedMealFoodItems = {
          ...data.cachedMealFoodItems,
        };

        if (listenToFoodItems) {
          for (final meal in meals) {
            if (!data.cachedMealFoodItems.containsKey(meal.id)) {
              final normalizedMealDate = _dateTimeToDate(meal.timestamp);

              final foodItemStream = _getFoodItemStreamByMealId(meal.id);
              if (_mealFoodItemsStreamSubscriptions[meal.id] != null) {
                _mealFoodItemsStreamSubscriptions[meal.id]?.cancel();
              }
              final foodItemSubscription = foodItemStream.listen((foodItems) {
                _foodItemsStreamCallback(
                    foodItems, normalizedMealDate, meal.id);
              });

              // Track the subscription for cleanup
              _mealFoodItemsStreamSubscriptions[meal.id] = foodItemSubscription;
            }
          }
        }

        // Get the stale meal ids by checking the ids of the meals in the previous cachedDateMeals for the current date
        final previousMealIds =
            data.cachedDateMeals[normalizedDate]?.map((w) => w.id).toSet() ??
                {};

        final currentMealIds = meals.map((w) => w.id).toSet();

        final staleMealIds = previousMealIds.difference(currentMealIds);
        for (final staleId in staleMealIds) {
          _mealFoodItemsStreamSubscriptions[staleId]?.cancel();
          _mealFoodItemsStreamSubscriptions.remove(staleId);
          updatedCachedMeals.remove(staleId);
          updatedMealFoodItems.remove(staleId);
        }

        // Update state
        state = AsyncValue.data(data.copyWith(
          cachedDateMeals: {
            ...data.cachedDateMeals,
            normalizedDate: meals,
          },
          cachedMeals: updatedCachedMeals,
          cachedMealFoodItems: updatedMealFoodItems,
        ));
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  Stream<List<FoodItem>> _getFoodItemStreamByMealId(String mealId) {
    final existingStream = _mealFoodItemsStreams[mealId];
    if (existingStream != null) {
      return existingStream;
    }

    final foodItemRepository = MealItemRepository(_authRepository, mealId);
    final newStream = foodItemRepository.getMealItemsStream();
    _mealFoodItemsStreams[mealId] = newStream;
    return newStream;
  }

  void listenToDate(DateTime date, bool listenToFoodItems) {
    final normalizedDate = _dateTimeToDate(date);
    state.when(
        data: (data) {
          if (!_dateMealsStreams.containsKey(normalizedDate)) {
            final stream =
                _mealRepository.getMealsStreamForDate(normalizedDate);

            // Listen to meal stream
            final subscription = stream.listen((meals) {
              _mealsStreamCallback(meals, normalizedDate, listenToFoodItems);
            });

            // Track date-based subscriptions for cleanup
            _dateMealsStreamSubscriptions[normalizedDate] = subscription;
            _dateMealsStreams[normalizedDate] = stream;
          } else if (listenToFoodItems &&
              !_datesWithFoodItemListeners.containsKey(normalizedDate)) {
            final oldSubscription =
                _dateMealsStreamSubscriptions[normalizedDate];
            final stream = _dateMealsStreams[normalizedDate];

            if (stream == null) {
              throw Exception('Stream not found for date $normalizedDate');
            }

            if (oldSubscription != null) {
              oldSubscription.cancel();
            }

            final subscription = stream.listen((meals) {
              _mealsStreamCallback(meals, normalizedDate, listenToFoodItems);
            });

            data.cachedDateMeals[normalizedDate]?.forEach((meal) {
              final foodItemStream = _getFoodItemStreamByMealId(meal.id);
              final foodItemSubscription = foodItemStream.listen((foodItems) {
                _foodItemsStreamCallback(foodItems, normalizedDate, meal.id);
              });

              _mealFoodItemsStreamSubscriptions[meal.id] = foodItemSubscription;
            });

            _dateMealsStreamSubscriptions[normalizedDate] = subscription;
          }
          if (listenToFoodItems) {
            _datesWithFoodItemListeners[normalizedDate] = true;
          }
        },
        loading: () {},
        error: (err, stack) {});
  }
}

class NutritionCacheState {
  final Map<DateTime, List<Meal>> cachedDateMeals;
  final Map<String, Meal> cachedMeals;
  final Map<String, List<FoodItem>> cachedMealFoodItems;

  NutritionCacheState({
    required this.cachedDateMeals,
    required this.cachedMeals,
    required this.cachedMealFoodItems,
  });

  NutritionCacheState copyWith({
    Map<DateTime, List<Meal>>? cachedDateMeals,
    Map<String, Meal>? cachedMeals,
    Map<String, List<FoodItem>>? cachedMealFoodItems,
  }) {
    return NutritionCacheState(
      cachedMeals: cachedMeals ?? this.cachedMeals,
      cachedDateMeals: cachedDateMeals ?? this.cachedDateMeals,
      cachedMealFoodItems: cachedMealFoodItems ?? this.cachedMealFoodItems,
    );
  }
}
