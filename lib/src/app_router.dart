import 'package:fit_and_healthy/src/features/dashboard/dashboard_appbar.dart';
import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:fit_and_healthy/src/features/settings/pages/profile_settings_page.dart';
import 'package:fit_and_healthy/src/features/settings/settings_view.dart';
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
            appBar = getSettingsAppBar(state.uri.toString(), context);
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
            path: '/settings',
            builder: (context, state) => const SettingsView(),
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => ProfileSettingsPage(),
              ),
              GoRoute(
                path: '/Theme',
                builder: (context, state) => Container(child: Text('Theme')),
              ),
            ],
          ),
        ])
      ],
    ),
  ],
);

PreferredSizeWidget getSettingsAppBar(String route, BuildContext context) {
  if (route.endsWith('/profile')) {
    return AppBar(
      title: Text('Profile Settings'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => context.go('/settings'), // Navigate back to /settings
      ),
    );
  } else if (route.endsWith('/theme')) {
    return AppBar(
      title: Text('Theme Settings'),
      centerTitle: true,
      leading: BackButton(onPressed: () => context.pop()),
    );
  } else {
    return AppBar(
      title: Text('Settings'),
      centerTitle: true,
    );
  }
}
