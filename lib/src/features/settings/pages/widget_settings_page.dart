import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/utils/card_provider.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      _expandedState[category] = false; // Default: all collapsed
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

  Widget _buildCategoryCard(
    BuildContext context,
    ThemeData theme,
    String categoryName,
    List<WidgetCard> categoryCards,
    List<WidgetCard> selectedCards,
    StateController<List<WidgetCard>> notifier,
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
                      notifier.state = List.from(notifier.state)..remove(card);
                    } else {
                      notifier.state = List.from(notifier.state)..add(card);
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

  Map<WidgetCardCategory, List<WidgetCard>> _groupCardsByCategory() {
    return {
      for (var category in WidgetCardCategory.values)
        category: allCards
            .where((card) => card.widgetCardCategory == category)
            .toList(),
    };
  }

  String _categoryName(WidgetCardCategory category) {
    switch (category) {
      case WidgetCardCategory.workout:
        return "Workouts";
      case WidgetCardCategory.nutrition:
        return 'Nutrition';
      case WidgetCardCategory.measurament:
        return 'Measurements';
      case WidgetCardCategory.other:
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  void _showCardPreview(BuildContext context, WidgetCard cardContent) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          overlayEntry.remove(); // Remove the overlay on tap
        },
        child: Stack(
          children: [
            // Semi-transparent background
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            // Centered card content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding around the card
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      (cardContent.size == 1.0
                          ? 1.0
                          : 0.5), // Width for 1.0 or 0.5
                  height: 200, // Set standard height (similar to dashboard)
                  child: cardContent.builder(), // Render the card's content
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
