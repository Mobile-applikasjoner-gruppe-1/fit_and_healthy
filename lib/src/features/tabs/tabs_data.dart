import 'package:fit_and_healthy/src/features/tabs/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<TabItem> tabs = [
  TabItem(
    title: 'Dashboard',
    icon: Icons.home,
    label: 'Dashboard',
    onTap: (navigationShell, context) =>
        navigationShell.goBranch(0, initialLocation: true),
  ),
  TabItem(
    title: 'Exercise',
    icon: Icons.fitness_center,
    label: 'Exercise',
    onTap: (navigationShell, context) =>
        navigationShell.goBranch(1, initialLocation: true),
  ),
  TabItem(
    title: 'Add',
    icon: Icons.add,
    label: 'Add',
    onTap: (navigationShell, context) => () => context.go(
          context.namedLocation('add'),
        ),
  ),
  TabItem(
    title: 'Nutrition',
    icon: Icons.restaurant,
    label: 'Nutrition',
    onTap: (navigationShell, context) =>
        navigationShell.goBranch(2, initialLocation: true),
  ),
  // "More" is a placeholder. We want 5 items in the bottom navigation bar, to make the add button centered, but have not yet decided what to put here.
  TabItem(
    title: 'More',
    icon: Icons.menu,
    label: 'More',
    onTap: (navigationShell, context) =>
        navigationShell.goBranch(3, initialLocation: true),
  ),
];
