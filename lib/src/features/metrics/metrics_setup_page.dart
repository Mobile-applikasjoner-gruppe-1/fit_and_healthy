import 'package:fit_and_healthy/shared/models/weight_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:fit_and_healthy/src/features/metrics/metric_state.dart';

/// This page allows users to set up or update their metrics information such as:
/// - Height
/// - Weight
/// - Gender
/// - Birthday
/// - Weight goal
/// - Activity level
///
/// It validates user input and updates the metrics state in the database.
class MetricsSetupPage extends ConsumerWidget {
  const MetricsSetupPage({super.key});

  static const route = '/setup-metrics';
  static const routeName = 'Setup Metrics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsController = ref.read(metricsControllerProvider.notifier);
    final metricsState = ref.watch(metricsControllerProvider).valueOrNull;

    final initialState = metricsState ??
        MetricsState(
          height: 170.0,
          weightHistory: [],
          gender: Gender.male,
          birthday: DateTime(2000, 1, 1),
          weeklyWorkoutGoal: 3,
          weightGoal: WeightGoal.maintain,
          activityLevel: ActivityLevel.moderatelyActive,
        );

    final _formKey = GlobalKey<FormState>();
    final heightController =
        TextEditingController(text: initialState.height.toString());
    final weightController = TextEditingController(
        text: initialState.weightHistory.isNotEmpty
            ? initialState.weightHistory.last.weight.toString()
            : '');
    Gender gender = initialState.gender;
    DateTime birthday = initialState.birthday;
    WeightGoal weightGoal = initialState.weightGoal;
    ActivityLevel activityLevel = initialState.activityLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Metrics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Height Input
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final height = double.tryParse(value ?? '');
                  if (height == null || height <= 0) {
                    return 'Please enter a valid height.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight Input
              TextFormField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final weight = double.tryParse(value ?? '');
                  if (weight == null || weight <= 0) {
                    return 'Please enter a valid weight.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender Input
              DropdownButtonFormField<Gender>(
                value: gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: Gender.values
                    .map(
                      (g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    gender = value;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Birthday Input
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText:
                      'Birthday: ${birthday.day}/${birthday.month}/${birthday.year}',
                  border: const OutlineInputBorder(),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: birthday,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    birthday = selectedDate;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Weight Goal
              DropdownButtonFormField<WeightGoal>(
                value: weightGoal,
                decoration: const InputDecoration(
                  labelText: 'Weight Goal',
                  border: OutlineInputBorder(),
                ),
                items: WeightGoal.values
                    .map(
                      (goal) => DropdownMenuItem(
                        value: goal,
                        child: Text(goal.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    weightGoal = value;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Activity Level
              DropdownButtonFormField<ActivityLevel>(
                value: activityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                items: ActivityLevel.values
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(level.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    activityLevel = value;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      final height = double.tryParse(heightController.text)!;
                      final weight = double.tryParse(weightController.text)!;

                      final updatedMetrics = MetricsState(
                        height: height,
                        weightHistory: initialState.weightHistory
                          ..add(WeightEntry(
                            id: '',
                            timestamp: DateTime.now(),
                            weight: weight,
                          )),
                        gender: gender,
                        birthday: birthday,
                        weeklyWorkoutGoal: initialState.weeklyWorkoutGoal,
                        weightGoal: weightGoal,
                        activityLevel: activityLevel,
                      );

                      await metricsController.addAllMetrics(updatedMetrics);
                      await metricsController.reloadAuthUserDataFromDB();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save metrics: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Save Metrics'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
