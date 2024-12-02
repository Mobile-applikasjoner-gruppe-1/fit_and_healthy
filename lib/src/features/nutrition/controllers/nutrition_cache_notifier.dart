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

    ref.read(firebaseAuthRepositoryProvider).userChanges().listen((user) {
      if (user == null) {
        _clearAllData();
      }
    });

    return NutritionCacheState(
      cachedDateMeals: {},
      cachedMeals: {},
      cachedMealFoodItems: {},
    );
  }

  void _clearAllData() {
    print('Clearing all data and subscriptions for NutritionCacheNotifier');

    // Cancel all subscriptions
    for (var subscription in _dateMealsStreamSubscriptions.values) {
      subscription.cancel();
    }
    for (var subscription in _mealFoodItemsStreamSubscriptions.values) {
      subscription.cancel();
    }

    // Clear all data
    _dateMealsStreamSubscriptions.clear();
    _dateMealsStreams.clear();
    _mealFoodItemsStreamSubscriptions.clear();
    _mealFoodItemsStreams.clear();
    _datesWithFoodItemListeners.clear();

    // Clear the state
    state = AsyncValue.data(NutritionCacheState(
      cachedDateMeals: {},
      cachedMeals: {},
      cachedMealFoodItems: {},
    ));
  }

  DateTime _dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  _foodItemsStreamCallback(
      List<FoodItem> foodItems, DateTime normalizedMealDate, String mealId) {
    state.when(
      data: (data) {
        try {
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
        } catch (e) {
          print("Error updating food items: $e");
        }
      },
      loading: () {},
      error: (err, stack) {},
    );
  }

  _mealsStreamCallback(
      List<Meal> meals, DateTime normalizedDate, bool listenToFoodItems) {
    state.when(
      data: (data) {
        try {
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
                try {
                  final normalizedMealDate = _dateTimeToDate(meal.timestamp);

                  final foodItemStream = _getFoodItemStreamByMealId(meal.id);
                  if (_mealFoodItemsStreamSubscriptions[meal.id] != null) {
                    _mealFoodItemsStreamSubscriptions[meal.id]?.cancel();
                  }
                  final foodItemSubscription =
                      foodItemStream.listen((foodItems) {
                    _foodItemsStreamCallback(
                        foodItems, normalizedMealDate, meal.id);
                  }, onError: (err) {
                    print('Error listening to food items stream: $err');
                  });

                  // Track the subscription for cleanup
                  _mealFoodItemsStreamSubscriptions[meal.id] =
                      foodItemSubscription;
                } catch (e) {
                  print("Error initializing food item stream: $e");
                  return;
                }
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
        } catch (e) {
          print("Error updating meals: $e");
        }
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
          try {
            if (!_dateMealsStreams.containsKey(normalizedDate)) {
              try {
                final stream =
                    _mealRepository.getMealsStreamForDate(normalizedDate);

                // Listen to meal stream
                final subscription = stream.listen((meals) {
                  _mealsStreamCallback(
                      meals, normalizedDate, listenToFoodItems);
                }, onError: (err) {
                  print('Error listening to meals stream: $err');
                });

                // Track date-based subscriptions for cleanup
                _dateMealsStreamSubscriptions[normalizedDate] = subscription;
                _dateMealsStreams[normalizedDate] = stream;
              } catch (e) {
                print("Error initializing meal stream: $e");
                return;
              }
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
              }, onError: (err) {
                print('Error listening to meals stream: $err');
              });

              data.cachedDateMeals[normalizedDate]?.forEach((meal) {
                final foodItemStream = _getFoodItemStreamByMealId(meal.id);
                final foodItemSubscription = foodItemStream.listen((foodItems) {
                  _foodItemsStreamCallback(foodItems, normalizedDate, meal.id);
                }, onError: (err) {
                  print('Error listening to food items stream: $err');
                });

                _mealFoodItemsStreamSubscriptions[meal.id] =
                    foodItemSubscription;
              });

              _dateMealsStreamSubscriptions[normalizedDate] = subscription;
            }
            if (listenToFoodItems) {
              _datesWithFoodItemListeners[normalizedDate] = true;
            }
          } catch (e) {
            print("Error listening to date: $e");
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
