import 'package:fit_and_healthy/src/features/dashboard/dashboard_appbar.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/settings/pages/profile_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/settings_appbar.dart';
import 'package:fit_and_healthy/src/features/settings/settings_view.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_workout_view.dart';
import 'package:fit_and_healthy/src/features/tabs/tabs_view.dart';
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
          PreferredSizeWidget appBar = defaultAppBar;
          switch (state.fullPath) {
            case DashboardView.route:
              appBar = DashboardAppbar;
              break;
            case '/exercise':
              // TODO: Should be defined in a separate file, like DashboardAppbar
              appBar = AppBar(title: Text('Exercise'), centerTitle: true);
              break;
            case '/nutrition':
              // TODO: Should be defined in a separate file, like DashboardAppbar
              appBar = AppBar(title: Text('Nutrition'), centerTitle: true);
              break;
            case SettingsView.routeName:
              appBar = SettingsAppBar;
              break;
            default:
              appBar = defaultAppBar;
          }

          return MaterialPage(
            child: TabsView(
              navigationShell: navigationShell,
              appBar: appBar,
            ),
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: DashboardView.route,
              builder: (context, state) => DashboardView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/exercise',
              builder: (context, state) =>
                  ExerciseView(workouts: sampleWorkouts),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/nutrition',
              builder: (context, state) =>
                  NutritionScreen(), // Changed to use NutritionScreen for the Nutrition tab
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: SettingsView.routeName,
                builder: (context, state) => SettingsView(),
                routes: [
                  GoRoute(
                    path: ProfileSettingsPage.routeName,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ProfileSettingsPage(),
                  )
                ]),
          ])
        ]),
  ],
);
