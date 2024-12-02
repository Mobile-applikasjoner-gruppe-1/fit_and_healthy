import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_cache_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/controllers/nutrition_date_notifier.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/meal.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/screens/meal_creation_screen.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/screens/meal_detail_screen.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/widgets/meal_view.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

void selectMeal(BuildContext context, Meal meal) {
  context
      .pushNamed(MealDetailScreen.routeName, pathParameters: {'id': meal.id});
}

void navigateToAddMeal(BuildContext context) {
  context.pushNamed(MealCreationScreen.routeName);
}

Widget _buildDateSelector(
  BuildContext context,
  WidgetRef ref,
  DateTime? selectedDate,
) {
  final displayDate = selectedDate ?? DateTime.now();
  final dateFormat = DateFormat('d');
  final monthFormat = DateFormat('MMMM');
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: () async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: displayDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                primary: theme.colorScheme.primary,
                onPrimary: theme.colorScheme.onPrimary,
                surface: theme.colorScheme.surface,
                onSurface: theme.colorScheme.onSurface,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedDate != null) {
        ref.read(nutritionDateNotifierProvider.notifier).changeDate(pickedDate);
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_left,
              size: 28,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              final newDate = displayDate.subtract(const Duration(days: 1));
              ref
                  .read(nutritionDateNotifierProvider.notifier)
                  .changeDate(newDate);
            },
          ),
          Column(
            children: [
              Text(
                dateFormat.format(displayDate),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                monthFormat.format(displayDate),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_right,
              size: 28,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              final newDate = displayDate.add(const Duration(days: 1));
              ref
                  .read(nutritionDateNotifierProvider.notifier)
                  .changeDate(newDate);
            },
          ),
        ],
      ),
    ),
  );
}

class MealListScreen extends ConsumerWidget {
  static const route = '/nutrition';
  static const routeName = 'Nutrition';

  _getTotalNutrition(List<Meal>? meals) {
    final totalNutrition = {
      'calories': 0.0,
      'protein': 0.0,
      'fat': 0.0,
      'sugars': 0.0,
      'fiber': 0.0,
      'carbs': 0.0,
    };

    if (meals == null) {
      return totalNutrition;
    }

    for (var meal in meals) {
      final mealNutrition = meal.calculateTotalNutrition();
      totalNutrition['calories'] =
          totalNutrition['calories']! + mealNutrition['calories']!;
      totalNutrition['protein'] =
          totalNutrition['protein']! + mealNutrition['protein']!;
      totalNutrition['fat'] = totalNutrition['fat']! + mealNutrition['fat']!;
      totalNutrition['sugars'] =
          totalNutrition['sugars']! + mealNutrition['sugars']!;
      totalNutrition['fiber'] =
          totalNutrition['fiber']! + mealNutrition['fiber']!;
      totalNutrition['carbs'] =
          totalNutrition['carbs']! + mealNutrition['carbs']!;
    }

    return totalNutrition;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget? loggedMeals;
    Widget? nutritionSummary;

    final nutritionDate = ref.watch(nutritionDateNotifierProvider);
    final nutritionCacheState = ref.watch(nutritionCacheNotifierProvider);

    DateTime? selectedDate;

    if (nutritionDate is AsyncLoading) {
      loggedMeals = const Center(child: CircularProgressIndicator());
    } else if (nutritionDate is AsyncError) {
      loggedMeals = Center(child: Text('Error: ${nutritionDate.error}'));
    } else {
      selectedDate = nutritionDate.value;
      if (selectedDate == null) {
        loggedMeals = const Center(child: CircularProgressIndicator());
      } else {
        final mealNotifier = ref.read(nutritionCacheNotifierProvider.notifier);
        mealNotifier.listenToDate(selectedDate, true);

        if (nutritionCacheState is AsyncLoading) {
          loggedMeals = const Center(child: CircularProgressIndicator());
        } else if (nutritionCacheState is AsyncError) {
          loggedMeals =
              Center(child: Text('Error: ${nutritionCacheState.error}'));
        } else {
          if (nutritionCacheState.value == null) {
            loggedMeals = const Center(child: CircularProgressIndicator());
          }

          final meals =
              nutritionCacheState.value!.cachedDateMeals[selectedDate];

          if (meals == null || meals.isEmpty) {
            loggedMeals = const Text(
              'No meals logged',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            );
          } else {
            final totalNutrition = _getTotalNutrition(meals);
            nutritionSummary = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Nutrition for All Meals:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      'Calories: ${totalNutrition['calories']!.toStringAsFixed(2)} kcal'),
                  Text(
                      'Protein: ${totalNutrition['protein']!.toStringAsFixed(2)} g'),
                  Text('Fat: ${totalNutrition['fat']!.toStringAsFixed(2)} g'),
                  Text(
                      'Sugars: ${totalNutrition['sugars']!.toStringAsFixed(2)} g'),
                  Text(
                      'Fiber: ${totalNutrition['fiber']!.toStringAsFixed(2)} g'),
                  Text(
                      'Carbs: ${totalNutrition['carbs']!.toStringAsFixed(2)} g'),
                ],
              ),
            );

            loggedMeals = ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meals.length,
              itemBuilder: (ctx, index) => MealView(
                meal: meals[index],
                onSelect: (meal) {
                  selectMeal(context, meal);
                },
              ),
            );
          }
        }
      }
    }

    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDateSelector(context, ref, selectedDate),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => navigateToAddMeal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Add Meal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (nutritionSummary != null) ...[
                  const SizedBox(height: 16),
                  nutritionSummary,
                ],
                const SizedBox(height: 16),
                const Text(
                  'Meals',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                loggedMeals,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
