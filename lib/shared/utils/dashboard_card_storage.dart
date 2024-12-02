import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fit_and_healthy/shared/models/widget_card.dart';

/// A utility class for saving and loading the selected widget cards
/// for the dashboard using `SharedPreferences`. This ensures that
/// the user's selection of cards persists between app sessions.
class DashboardCardStorage {
  static const String _keySelectedCards = 'selected_cards';

  /// The method serializes the list of card IDs and stores them
  /// in `SharedPreferences` under a predefined key.
  static Future<void> saveSelectedCards(List<WidgetCard> selectedCards) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardIds = selectedCards.map((card) => card.id).toList();
      await prefs.setString(_keySelectedCards, json.encode(cardIds));
    } catch (e) {
      print("Error saving selected cards: $e");
    }
  }

  /// The method retrieves the saved card IDs from `SharedPreferences` and
  /// filters the provided list of all available cards to include only the
  /// selected ones.
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
