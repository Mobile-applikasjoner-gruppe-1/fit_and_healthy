import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/utils/card_provider.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A page that allows users to manage and customize their widget cards.
/// It groups the cards by category, allows users to select or deselect cards,
/// and provides a preview feature for each card.
class WidgetSettingsPage extends ConsumerStatefulWidget {
  const WidgetSettingsPage({super.key});

  static const route = '/widget';
  static const routeName = 'Widget Settings';

  @override
  ConsumerState<WidgetSettingsPage> createState() => _WidgetSettingsPageState();
}

class _WidgetSettingsPageState extends ConsumerState<WidgetSettingsPage> {
  final Map<WidgetCardCategory, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();
    for (var category in WidgetCardCategory.values) {
      _expandedState[category] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCards = ref.watch(CardProvider);
    final notifier = ref.read(CardProvider.notifier);
    final theme = Theme.of(context);

    final groupedCards = _groupCardsByCategory();

    return NestedScaffold(
      appBar: AppBar(title: const Text('Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: groupedCards.entries.map((entry) {
            final categoryName = _categoryName(entry.key);
            final categoryCards = entry.value;

            return _buildCategoryCard(
              context,
              theme,
              categoryName,
              categoryCards,
              selectedCards,
              notifier,
              entry.key,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Builds a card for a specific widget category and its cards.
  Widget _buildCategoryCard(
    BuildContext context,
    ThemeData theme,
    String categoryName,
    List<WidgetCard> categoryCards,
    List<WidgetCard> selectedCards,
    CardNotifier notifier,
    WidgetCardCategory category,
  ) {
    final isExpanded = _expandedState[category] ?? false;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              categoryName,
              style: theme.textTheme.headlineSmall,
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _expandedState[category] = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Column(
              children: categoryCards.map((card) {
                final isSelected = selectedCards.contains(card);
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      notifier.removeCard(card);
                    } else {
                      notifier.addCard(card);
                    }
                  },
                  child: Card(
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.surface,
                    elevation: 0,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.title,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  card.size == 1.0
                                      ? 'Full width'
                                      : 'Half width',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              _showCardPreview(context, card);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Groups all available cards by their respective categories.
  Map<WidgetCardCategory, List<WidgetCard>> _groupCardsByCategory() {
    return {
      for (var category in WidgetCardCategory.values)
        category: allCards
            .where((card) => card.widgetCardCategory == category)
            .toList(),
    };
  }

  /// Maps the widget card category enum to its display name.
  String _categoryName(WidgetCardCategory category) {
    switch (category) {
      case WidgetCardCategory.workout:
        return "Workouts";
      case WidgetCardCategory.nutrition:
        return 'Nutrition';
      case WidgetCardCategory.measurament:
        return 'Measurements';
      default:
        return 'Unknown';
    }
  }

  /// Displays a full-screen preview of the card content.
  void _showCardPreview(BuildContext context, WidgetCard cardContent) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          overlayEntry.remove();
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      (cardContent.size == 1.0 ? 1.0 : 0.5),
                  height: 200,
                  child: cardContent.builder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}
