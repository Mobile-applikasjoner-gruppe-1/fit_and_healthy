import 'package:fit_and_healthy/src/features/tabs/tab_item.dart';
import 'package:flutter/material.dart';

List<TabItem> tabs = [
  TabItem(
    title: 'Dashboard',
    icon: Icons.home,
    label: 'Dashboard',
    onTap: (navigationShell) => navigationShell.goBranch(0),
  ),
  TabItem(
    title: 'Exercise',
    icon: Icons.fitness_center,
    label: 'Exercise',
    onTap: (navigationShell) => navigationShell.goBranch(1),
  ),
  TabItem(
    title: 'Add',
    icon: Icons.add,
    label: 'Add',
    onTap: (navigationShell) => {
      // TODO: Do something when clicking the add button
      print('Add button clicked')
    },
  ),
  TabItem(
    title: 'Nutrition',
    icon: Icons.restaurant,
    label: 'Nutrition',
    onTap: (navigationShell) => navigationShell.goBranch(2),
  ),
  // "More" is a placeholder. We want 5 items in the bottom navigation bar, to make the add button centered, but have not yet decided what to put here.
  TabItem(
    title: 'More',
    icon: Icons.menu,
    label: 'More',
    onTap: (navigationShell) => navigationShell.goBranch(3),
  ),
];
