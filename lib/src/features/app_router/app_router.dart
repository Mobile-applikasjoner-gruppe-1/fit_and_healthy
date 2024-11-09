import 'package:fit_and_healthy/src/features/app_router/app_router_redirect.dart';
import 'package:fit_and_healthy/src/features/auth/auth_repository/firebase_auth_repository.dart';
import 'package:fit_and_healthy/src/features/auth/login/login_view.dart';
import 'package:fit_and_healthy/src/utils/stream_listenable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fit_and_healthy/src/features/auth/register/register_view.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_appbar.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/tabs/tabs_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    refreshListenable:
        StreamListenable(firebaseAuthRepository.authStateChanges()),
    redirect: (context, state) =>
        appRouterRedirectHandler(context, state, firebaseAuthRepository),
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
              case '/something-else':
                // TODO: Should be defined in a separate file, like DashboardAppbar
                appBar =
                    AppBar(title: Text('Something else'), centerTitle: true);
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
                // TODO: Should be defined in a separate file, like DashboardView
                builder: (context, state) => Container(
                  child: Text('Exercise'),
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/nutrition',
                // TODO: Should be defined in a separate file, like DashboardView
                builder: (context, state) => Container(
                  child: Text('Nutrition'),
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/something-else',
                // TODO: Should be defined in a separate file, like DashboardView
                builder: (context, state) => Container(
                  child: Text('Something else'),
                ),
              ),
            ])
          ]),
      GoRoute(
        path: LoginView.route,
        name: LoginView.routeName,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: LoginView(),
          );
        },
      ),
      GoRoute(
        path: RegisterView.route,
        name: RegisterView.routeName,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: RegisterView(),
          );
        },
      ),
    ],
  );
}
