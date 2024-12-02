import 'package:flutter/material.dart';

enum WidgetCardCategory {
  workout,
  nutrition,
  measurament,
}

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
