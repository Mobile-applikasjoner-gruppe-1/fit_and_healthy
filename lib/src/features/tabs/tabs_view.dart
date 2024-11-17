import 'package:fit_and_healthy/src/features/tabs/tabs_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TabsView extends ConsumerWidget {
  const TabsView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int _getTabIndex() {
      final index = navigationShell.currentIndex;
      switch (index) {
        case 0:
        case 1:
          return index;
        case 2:
        case 3:
          return index + 1;
        default:
          return 0;
      }
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) =>
            tabs[index].onTap(navigationShell, context),
        selectedIndex: _getTabIndex(),
        destinations: tabs
            .map((tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ))
            .toList(),
      ),
    );
  }
}
