import 'package:fit_and_healthy/src/features/auth/add_display_name/add_display_name_view.dart';
import 'package:fit_and_healthy/src/features/auth/email_verification/email_verification_view.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_setup_page.dart';
import 'package:fit_and_healthy/src/features/routing/app_router_redirect.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/forgot_password/forgot_password_view.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_view.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_view.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_add_exercise.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_add_workout.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_workout_detail.dart';
import 'package:fit_and_healthy/src/features/exercise/screens/exercise_workout_view.dart';
import 'package:fit_and_healthy/src/features/gdpr_policy/gdpr_settings_page.dart';
import 'package:fit_and_healthy/src/features/goals/goals_settings_page.dart';
import 'package:fit_and_healthy/src/features/metrics/measurement_settings_page.dart';
import 'package:fit_and_healthy/src/features/gdpr_policy/privacy_gdpr_policy_settings_page.dart';
import 'package:fit_and_healthy/src/features/profile/profile_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/settings_view.dart';
import 'package:fit_and_healthy/src/features/tabs/tabs_view.dart';
import 'package:fit_and_healthy/src/features/nutrition/food_item_widget/food_search_screen.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/screens/meal_creation_screen.dart';
import 'package:fit_and_healthy/src/features/nutrition/nutrition_screen.dart';
import 'package:fit_and_healthy/src/utils/stream_listenable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_and_healthy/src/features/exercise/exercise_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'Root Navigator');

PreferredSizeWidget defaultAppBar =
    AppBar(title: Text('Fit and Healthy'), centerTitle: true);

@riverpod
GoRouter appRouter(Ref ref) {
  final firebaseAuthRepository = ref.watch(firebaseAuthRepositoryProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: StreamListenable(firebaseAuthRepository.userChanges()),
    redirect: (context, state) =>
        appRouterRedirectHandler(context, state, firebaseAuthRepository),
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
                builder: (context, state) {
                  return ExerciseView();
                },
                routes: [
                  GoRoute(
                    path: 'add-workout',
                    name: 'AddWorkout',
                    builder: (context, state) =>
                        AddWorkout(workouts: sampleWorkouts),
                  ),
                  GoRoute(
                      path: 'add-exercise:id',
                      name: 'AddExercise',
                      builder: (context, state) {
                        final workoutId = state.pathParameters['id']!;
                        return AddExercise(
                            workouts: sampleWorkouts, workoutId: workoutId);
                      }),
                  GoRoute(
                    path: ':id',
                    name: 'WorkoutDetail',
                    builder: (context, state) {
                      final workoutId = state.pathParameters['id']!;
                      return WorkoutDetailView(
                          workoutId: workoutId, workouts: sampleWorkouts);
                    },
                  ),
                ],
              ),
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
                  //     },
                  // ),
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
                      routes: [
                        GoRoute(
                          path: PrivacyGdprPolicySettingsPage.route,
                          name: PrivacyGdprPolicySettingsPage.routeName,
                          builder: (context, state) =>
                              PrivacyGdprPolicySettingsPage(),
                        )
                      ],
                    )
                  ]),
            ])
          ]),
      GoRoute(
        path: LoginView.route,
        name: LoginView.routeName,
        builder: (context, state) {
          return LoginView();
        },
      ),
      GoRoute(
        path: RegisterView.route,
        name: RegisterView.routeName,
        builder: (context, state) {
          return RegisterView();
        },
      ),
      GoRoute(
        path: ForgotPasswordView.route,
        name: ForgotPasswordView.routeName,
        builder: (context, state) {
          return ForgotPasswordView();
        },
      ),
      GoRoute(
        path: EmailVerificationView.route,
        name: EmailVerificationView.routeName,
        builder: (context, state) {
          return EmailVerificationView();
        },
      ),
      GoRoute(
        path: AddDisplayNameView.route,
        name: AddDisplayNameView.routeName,
        builder: (context, state) {
          return AddDisplayNameView();
        },
      ),
      GoRoute(
        path: MetricsSetupPage.route,
        name: MetricsSetupPage.routeName,
        builder: (context, state) {
          return MetricsSetupPage();
        },
      ),
    ],
  );
}
