import 'package:fit_and_healthy/shared/models/WeightEntry.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

// Riverpod Provider for managing weight entries
final weightEntriesProvider = StateProvider<List<WeightEntry>>((ref) => []);

class MeasurementSettingsPage extends ConsumerWidget {
  const MeasurementSettingsPage({super.key});

  static const route = '/measurement';
  static const routeName = 'Measurement Settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightEntries = ref.watch(weightEntriesProvider);
    final weightNotifier = ref.read(weightEntriesProvider.notifier);

    final TextEditingController weightController = TextEditingController();

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
              'Update Your Weight',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Input Field to Update Weight
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final double? weight =
                        double.tryParse(weightController.text);
                    if (weight != null) {
                      // Update the weightEntriesProvider state
                      weightNotifier.update((state) {
                        return [
                          ...state,
                          WeightEntry(
                            timestamp: DateTime.now(),
                            weight: weight,
                          ),
                        ];
                      });
                      weightController.clear(); // Clear the input field
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid weight.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Weight Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Chart
            Expanded(
              child: weightEntries.isEmpty
                  ? Center(
                      child: Text(
                        'No weight data yet.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LineChart(
                        _buildLineChart(weightEntries),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChart(List<WeightEntry> entries) {
    final spots = entries
        .asMap()
        .entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), entry.value.weight.toDouble()))
        .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        horizontalInterval: 5,
        verticalInterval: 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.5),
          strokeWidth: 0.5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.5),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}kg',
                style: const TextStyle(fontSize: 10),
              );
            },
            reservedSize: 40,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= entries.length) return const SizedBox.shrink();
              final date = entries[index].timestamp;
              return Text(
                '${date.day}/${date.month}',
                style: const TextStyle(fontSize: 10),
              );
            },
            reservedSize: 30,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: spots,
          barWidth: 4,
          color: Colors.blue,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.3),
                Colors.blue.withOpacity(0)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
    );
  }
}
