import 'package:fit_and_healthy/shared/utils/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCards = ref.watch(CardProvider);

    return selectedCards.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'There are no widgets selected yet!',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.push('/settings/widget');
                  },
                  child: Text('Add new'),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                    // TODO, add a predifined list and add it to the current selected cards
                    onPressed: () {
                      ref.read(CardProvider.notifier).state = [...allCards];
                    },
                    child: Text('Add Default'))
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: selectedCards.length,
              itemBuilder: (context, index) {
                final card = selectedCards[index];
                return card.builder();
              },
            ),
          );
  }
}
