import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_amount_weekly_workout.dart';
import 'package:fit_and_healthy/shared/widgets/cards/card_weight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allCards = [
  WidgetCard(
      id: '1',
      title: 'Workout amount weekly',
      size: 0.5,
      widgetCardCategory: WidgetCardCategory.workout,
      builder: () => CardAmountWeeklyWorkout()),
  WidgetCard(
      id: '2',
      title: 'Workout amount weekly 2',
      size: 1.0,
      widgetCardCategory: WidgetCardCategory.workout,
      builder: () => CardAmountWeeklyWorkout()),
  WidgetCard(
    id: '3',
    title: 'Weight',
    size: 1.0,
    widgetCardCategory: WidgetCardCategory.measurament,
    builder: () => CardWeight(),
  ),
];

final CardProvider = StateProvider<List<WidgetCard>>((ref) => []);
