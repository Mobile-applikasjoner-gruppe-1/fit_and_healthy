import 'package:fit_and_healthy/shared/models/weight_entry.dart';
import 'package:fit_and_healthy/shared/widgets/charts/weight_chart.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardWeight extends ConsumerWidget {
  const CardWeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsState = ref.watch(metricsControllerProvider);
    final List<WeightEntry> weightEntries = metricsState.maybeWhen(
      data: (metrics) => metrics.weightHistory.cast<WeightEntry>(),
      orElse: () => [],
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.green.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Icon
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  //Icon(Icons.monitor_weight, color: Colors.white),
                ],
              ),
            ),
            // Chart
            SizedBox(
              height: 100, // Fixed height for chart
              child: WeightChart(entries: weightEntries), // Reuse WeightChart
            ),
          ],
        ),
      ),
    );
  }
}
