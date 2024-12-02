import 'package:flutter/material.dart';

/// Enum representing the category of a widget card.
///
/// Categories:
/// - [workout]: Represents workout-related widgets.
/// - [nutrition]: Represents nutrition-related widgets.
/// - [measurament]: Represents measurement-related widgets.
enum WidgetCardCategory {
  workout,
  nutrition,
  measurament,
}

/// A class representing a widget card.
///
/// A widget card is a customizable component that can be displayed on a
/// dashboard. Each card has an ID, title, size, category, a builder function,
/// and an optional route for navigation.

class WidgetCard {
  final String id;
  final String title;
  final double size;
  final WidgetCardCategory widgetCardCategory;
  final Widget Function() builder;
  final String? route;

  const WidgetCard({
    required this.id,
    required this.title,
    required this.size,
    required this.widgetCardCategory,
    required this.builder,
    this.route,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'size': size,
        'widgetCardCategory': widgetCardCategory.index,
        'route': route,
      };

  static WidgetCard fromJson(
      Map<String, dynamic> json, List<WidgetCard> allCards) {
    return allCards.firstWhere((card) => card.id == json['id']);
  }
}
