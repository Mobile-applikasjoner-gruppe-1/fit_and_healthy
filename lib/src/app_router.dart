import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/settings/pages/gdpr_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/pages/goals_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/pages/measurement_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/pages/profile_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/settings_view.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_workout_view.dart';
import 'package:fit_and_healthy/src/features/tabs/tabs_view.dart';
import 'package:fit_and_healthy/src/openfoodfacts/fooditemwidgets/foodSearchScreen.dart';
import 'package:fit_and_healthy/src/openfoodfacts/mealCreationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_data.dart';

import 'openfoodfacts/nutritionScreen.dart';

final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'Root Navigator');

PreferredSizeWidget defaultAppBar =
    AppBar(title: Text('Fit and Healthy'), centerTitle: true);

GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return CupertinoPage(
            child: TabsView(
              navigationShell: navigationShell,
            ),
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: DashboardView.route,
              name: DashboardView.routeName,
              builder: (context, state) => DashboardView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: ExerciseView.route,
                name: ExerciseView.routeName,
                builder: (context, state) =>
                    ExerciseView(workouts: sampleWorkouts),
                routes: [
                  // TODO: Switch to a routing based approach to navigate to the WorkoutDetailView. Use path parameters to pass the workout id.
                  // GoRoute(
                  //   path: WorkoutDetailView.route,
                  //   builder: (context, state) {
                  //     final workoutId = state.pathParameters['workoutId']!;
                  //     final workout = sampleWorkouts
                  //         .firstWhere((workout) => workout.id == workoutId);
                  //     return WorkoutDetailView(workout: workout);
                  //   },
                  // )
                ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NutritionScreen.route,
              name: NutritionScreen.routeName,
              builder: (context, state) => NutritionScreen(),
              routes: [
                GoRoute(
                  path: FoodSearchScreen.route,
                  name: FoodSearchScreen.routeName,
                  builder: (context, state) => FoodSearchScreen(),
                ),
                GoRoute(
                    path: MealListScreen.route,
                    name: MealListScreen.routeName,
                    builder: (context, state) {
                      return MealListScreen();
                    }),
                // TODO: Use a route parameter to pass the mealId to the MealDetailScreen instead of passing the entire Meal
                // GoRoute(
                //     path: MealDetailScreen.route,
                //     name: MealDetailScreen.routeName,
                //     builder: (context, state) {
                //       final mealId = state.pathParameters['mealId']!;
                //       return MealDetailScreen(
                //         mealId: mealId,
                //       );
                //     }),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: SettingsView.route,
                name: SettingsView.routeName,
                builder: (context, state) => SettingsView(),
                routes: [
                  GoRoute(
                    path: ProfileSettingsPage.route,
                    name: ProfileSettingsPage.routeName,
                    builder: (context, state) => ProfileSettingsPage(),
                  ),
                  GoRoute(
                    path: MeasurementSettingsPage.route,
                    name: MeasurementSettingsPage.routeName,
                    builder: (context, state) => MeasurementSettingsPage(),
                  ),
                  GoRoute(
                    path: GoalsSettingsPage.route,
                    name: GoalsSettingsPage.routeName,
                    builder: (context, state) => GoalsSettingsPage(),
                  ),
                  GoRoute(
                    path: GdprSettingsPage.route,
                    name: GdprSettingsPage.routeName,
                    builder: (context, state) => GdprSettingsPage(),
                  )
                ]),
          ])
        ]),
  ],
);
