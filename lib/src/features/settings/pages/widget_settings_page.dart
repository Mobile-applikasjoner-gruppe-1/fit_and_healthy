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
              ),
            ),
          );
        },
      ),
    );
  }
}
