import 'package:fit_and_healthy/shared/models/widget_card.dart';
import 'package:fit_and_healthy/shared/utils/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetSettingsPage extends ConsumerWidget {
  const WidgetSettingsPage({super.key});

  static const routeName = '/widget';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCards = ref.watch(CardProvider);
    final notifier = ref.read(CardProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Widgets')),
      body: ListView.builder(
        itemCount: allCards.length,
        itemBuilder: (context, index) {
          final card = allCards[index];
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
              color: isSelected ? Colors.blue[100] : Colors.white,
              child: ListTile(
                title: Text(card.title),
                trailing: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    _showCardPreview(context, card);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        (cardContent.size == 1.0
                            ? 0.9
                            : 0.45), // Adjust width based on size
                    maxHeight: 300, // Optional: limit height
                  ),
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: cardContent.builder(), // Render the card's content
                    ),
                  ),
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
