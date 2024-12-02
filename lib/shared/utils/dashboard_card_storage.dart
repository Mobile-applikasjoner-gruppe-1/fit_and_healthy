import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fit_and_healthy/shared/models/widget_card.dart';

class DashboardCardStorage {
  static const String _keySelectedCards = 'selected_cards';

  static Future<void> saveSelectedCards(List<WidgetCard> selectedCards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardIds = selectedCards.map((card) => card.id).toList();
      await prefs.setString(_keySelectedCards, json.encode(cardIds));
    } catch (e) {
      print("Error saving selected cards: $e");
    }
  }

  static Future<List<WidgetCard>> loadSelectedCards(
      List<WidgetCard> allCards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCardIds = prefs.getString(_keySelectedCards);

      if (savedCardIds != null) {
        final List<String> cardIds =
            List<String>.from(json.decode(savedCardIds));
        return allCards.where((card) => cardIds.contains(card.id)).toList();
      }
    } catch (e) {
      print("Error loading selected cards: $e");
    }
    return [];
  }
}
