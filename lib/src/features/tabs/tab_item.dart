import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabItem {
  final String title;
  final IconData icon;
  final String label;
  final Function(StatefulNavigationShell, BuildContext) onTap;

  const TabItem({
    required this.title,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
