import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/shared/widgets/charts/weight_chart.dart';

// Providers
final weightEntriesProvider = StateProvider<List<WeightEntry>>((ref) => []);
final chartFilterProvider =
    StateProvider<ChartFilter>((ref) => ChartFilter.all);

enum ChartFilter { month, year, all }

class MeasurementSettingsPage extends ConsumerWidget {
  const MeasurementSettingsPage({super.key});

  static const route = '/measurement';
  static const routeName = 'Measurement Settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightEntries = ref.watch(weightEntriesProvider);
    final filter = ref.watch(chartFilterProvider);

    // Filter entries based on the selected filter
    final filteredEntries = _filterEntries(weightEntries, filter);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Measurement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Chart Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(
                    context, ref, ChartFilter.month, 'Past Month'),
                _buildFilterButton(context, ref, ChartFilter.year, 'Past Year'),
                _buildFilterButton(context, ref, ChartFilter.all, 'All Time'),
              ],
            ),
            const SizedBox(height: 16),
            // Reusable Chart
            Expanded(child: WeightChart(entries: filteredEntries)),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showAddWeightModal(context, ref);
                },
                child: const Text('Add Weight'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Button
  Widget _buildFilterButton(
    BuildContext context,
    WidgetRef ref,
    ChartFilter filter,
    String label,
  ) {
    final currentFilter = ref.watch(chartFilterProvider);
    final isSelected = currentFilter == filter;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        foregroundColor:
            isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () {
        ref.read(chartFilterProvider.notifier).state = filter;
      },
      child: Text(label),
    );
  }

  // Filter Entries Based on Selected Filter
  List<WeightEntry> _filterEntries(
      List<WeightEntry> entries, ChartFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case ChartFilter.month:
        return entries
            .where((entry) =>
                entry.timestamp.isAfter(now.subtract(const Duration(days: 30))))
            .toList();
      case ChartFilter.year:
        return entries
            .where((entry) => entry.timestamp
                .isAfter(now.subtract(const Duration(days: 365))))
            .toList();
      case ChartFilter.all:
        return entries;
    }
  }

  // Show Modal Bottom Sheet
  void _showAddWeightModal(BuildContext context, WidgetRef ref) {
    final weightNotifier = ref.read(weightEntriesProvider.notifier);
    final TextEditingController weightController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add Weight',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    'Pick Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final double? weight =
                          double.tryParse(weightController.text);
                      if (weight != null) {
                        weightNotifier.update((state) {
                          final updatedState = [
                            ...state,
                            WeightEntry(
                              timestamp: selectedDate,
                              weight: weight,
                            ),
                          ];
                          updatedState.sort((a, b) =>
                              a.timestamp.compareTo(b.timestamp)); // Sort
                          return updatedState;
                        });
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid weight.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Save Weight'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
