import 'package:fit_and_healthy/src/features/dashboard/dashboard_appbar.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/tabs/tabs_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

PreferredSizeWidget defaultAppBar =
    AppBar(title: Text('Fit and Healthy'), centerTitle: true);

GoRouter appRouter = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          PreferredSizeWidget appBar = defaultAppBar;
          switch (navigationShell.currentIndex) {
            case 0:
              appBar = DashboardAppbar;
              break;
            case 1:
              // TODO: Should be defined in a separate file, like DashboardAppbar
              appBar = AppBar(title: Text('Exercise'), centerTitle: true);
              break;
            case 2:
              // TODO: Should be defined in a separate file, like DashboardAppbar
              appBar = AppBar(title: Text('Nutrition'), centerTitle: true);
              break;
            case 3:
              // TODO: Should be defined in a separate file, like DashboardAppbar
              appBar = AppBar(title: Text('Something else'), centerTitle: true);
              break;
            default:
              appBar = defaultAppBar;
          }

          return TabsView(
            navigationShell: navigationShell,
            appBar: appBar,
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => DashboardView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/exercise',
              builder: (context, state) => Container(
                child: Text('Exercise'),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/nutrition',
              builder: (context, state) => Container(
                child: Text('Nutrition'),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/something-else',
              builder: (context, state) => Container(
                child: Text('Something else'),
              ),
            ),
          ])
        ]),
  ],
);
