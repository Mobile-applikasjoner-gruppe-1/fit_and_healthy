import 'package:fit_and_healthy/shared/utils/card_provider.dart';
import 'package:fit_and_healthy/src/features/settings/settings_widget_page.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// This is the main dashboard view of the application, where users can see a
/// grid of selected widgets. It provides the following functionalities:
/// - Displays widgets selected by the user.
/// - Allows users to navigate to a widget settings page to add widgets.
/// - Provides an option to add default widgets if none are selected.
class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  static const route = '/';
  static const routeName = 'Dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCards = ref.watch(CardProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(CardProvider.notifier)
          .loadCards(ref.read(allCardsProvider));
    });

    return NestedScaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: selectedCards.isEmpty
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
                      context.pushNamed(WidgetSettingsPage.routeName);
                    },
                    child: Text('Add new'),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(CardProvider.notifier).setDefaultCards([
                        '5',
                        '4',
                        '6',
                      ]);
                    },
                    child: Text('Add Default'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: selectedCards.map((card) {
                    return StaggeredGridTile.count(
                      crossAxisCellCount: card.size == 1.0 ? 2 : 1,
                      mainAxisCellCount: 1,
                      child: GestureDetector(
                        onTap: () {
                          if (card.route != null) {
                            context.pushNamed(card.route!);
                          }
                        },
                        child: card.builder(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
