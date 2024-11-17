import 'package:flutter/material.dart';

enum WidgetCardCategory {
  workout,
  nutrition,
  measurament,
  other,
}

class WidgetCard {
  final String id;
  final String title;
  final double size;
  final WidgetCardCategory widgetCardCategory;
  final Widget Function() builder;

  const WidgetCard({
    required this.id,
    required this.title,
    required this.size,
    required this.widgetCardCategory,
    required this.builder,
  });
}
