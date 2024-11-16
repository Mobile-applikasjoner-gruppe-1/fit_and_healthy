import 'package:flutter/material.dart';

class WidgetCard {
  final String id;
  final String title;
  final double size;
  final Widget Function() builder;

  const WidgetCard({
    required this.id,
    required this.title,
    required this.size,
    required this.builder,
  });
}
