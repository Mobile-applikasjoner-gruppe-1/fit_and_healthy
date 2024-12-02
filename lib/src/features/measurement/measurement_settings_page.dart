import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/weight_entry.dart';
import 'package:fit_and_healthy/shared/widgets/charts/weight_chart.dart';

/// A state provider for managing the selected chart filter.
final chartFilterProvider =
    StateProvider<ChartFilter>((ref) => ChartFilter.all);

/// Enum representing available chart filters: month, year, or all time.
enum ChartFilter { month, year, all }

// This page allows users to view and manage their weight measurements over time.
/// It displays a weight progress chart with filter options (past month, past year, all time),
/// and provides functionality to add new weight entries.
class MeasurementSettingsPage extends ConsumerWidget {
  const MeasurementSettingsPage({super.key});

  static const route = '/measurement';
  static const routeName = 'Measurement Settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricState = ref.watch(metricsControllerProvider);
    final metricsController = ref.read(metricsControllerProvider.notifier);

    if (metricState is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (metricState is AsyncError) {
      return Center(child: Text('Error: ${metricState.error}'));
    }

    final data = metricState.value;

    if (data == null) {
      return const Center(child: Text('No data available.'));
    }

    final weightHistory = data.weightHistory;
    final filter = ref.watch(chartFilterProvider);
    final filteredEntries = _filterEntries(weightHistory, filter);

    return NestedScaffold(
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: WeightChart(entries: filteredEntries),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'For accurate results:\n'
                '- Weigh yourself at the same time daily, preferably in the morning.\n'
                '- Do it before eating or drinking.\n'
                '- After using the toilet.\n'
                '- Once a week on the same day for consistent tracking.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showAddWeightModal(context, metricsController);
                    },
                    child: const Text('Add Weight'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteWeightModal(
                          context, weightHistory, metricsController);
                    },
                    child: const Text('Delete Weight'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a filter button for the chart.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [ref]: The Riverpod reference.
  /// - [filter]: The filter type (month, year, or all).
  /// - [label]: The button label.
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

  /// Filters weight entries based on the selected chart filter.
  ///
  /// Parameters:
  /// - [entries]: List of weight entries.
  /// - [filter]: The selected chart filter.
  ///
  /// Returns:
  /// - A filtered list of weight entries sorted by timestamp.
  List<WeightEntry> _filterEntries(
      List<WeightEntry> entries, ChartFilter filter) {
    final now = DateTime.now();
    List<WeightEntry> filtered;
    switch (filter) {
      case ChartFilter.month:
        filtered = entries
            .where((entry) =>
                entry.timestamp.isAfter(now.subtract(const Duration(days: 30))))
            .toList();
        break;
      case ChartFilter.year:
        filtered = entries
            .where((entry) => entry.timestamp
                .isAfter(now.subtract(const Duration(days: 365))))
            .toList();
        break;
      case ChartFilter.all:
        filtered = entries;
        break;
    }

    filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return filtered;
  }

  /// Displays a modal for adding a new weight entry.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [metricsController]: The metrics controller for handling weight entry.
  void _showAddWeightModal(
      BuildContext context, MetricsController metricsController) {
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
                      lastDate: DateTime.now(),
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
                    onPressed: () async {
                      final double? weight =
                          double.tryParse(weightController.text);
                      if (weight != null) {
                        try {
                          await metricsController.addWeightEntry(
                              weight, selectedDate);
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter valid values.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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

  void _showDeleteWeightModal(
    BuildContext context,
    List<WeightEntry> weightHistory,
    MetricsController metricsController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
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
                'Delete Weight Entries',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: weightHistory.length,
                itemBuilder: (context, index) {
                  final entry = weightHistory[index];
                  return ListTile(
                    title: Text(
                      '${entry.weight} kg',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      '${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text(
                              'Are you sure you want to delete the entry for ${entry.weight} kg?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          try {
                            await metricsController.deleteWeight(entry.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Weight entry deleted successfully.'),
                              ),
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to delete weight entry.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
