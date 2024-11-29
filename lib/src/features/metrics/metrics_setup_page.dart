import 'package:fit_and_healthy/src/features/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';
import 'package:go_router/go_router.dart';

class MetricsSetupPage extends ConsumerStatefulWidget {
  const MetricsSetupPage({super.key});

  static const route = '/setup-metrics';
  static const routeName = 'Setup Metrics';

  @override
  _MetricsSetupPageState createState() => _MetricsSetupPageState();
}

class _MetricsSetupPageState extends ConsumerState<MetricsSetupPage> {
  final _formKey = GlobalKey<FormState>();
  double? _height;
  double? _weight;
  Gender? _gender = Gender.male;
  DateTime? _birthday;
  WeightGoal? _weightGoal = WeightGoal.maintain;
  ActivityLevel? _activityLevel = ActivityLevel.moderatelyActive;

  @override
  Widget build(BuildContext context) {
    final metricsController = ref.read(metricsControllerProvider.notifier);

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
                onSaved: (value) {
                  _height = double.tryParse(value ?? '');
                },
              ),
              const SizedBox(height: 16),

              // Weight Input
              TextFormField(
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
                onSaved: (value) {
                  _weight = double.tryParse(value ?? '');
                },
              ),
              const SizedBox(height: 16),

              // Gender Input
              DropdownButtonFormField<Gender>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: Gender.values
                    .map(
                      (gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _gender = value;
                }),
              ),
              const SizedBox(height: 16),

              // Birthday Input
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: _birthday == null
                      ? 'Select Birthday'
                      : 'Birthday: ${_birthday!.day}/${_birthday!.month}/${_birthday!.year}',
                  border: const OutlineInputBorder(),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _birthday = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Weight Goal
              DropdownButtonFormField<WeightGoal>(
                value: _weightGoal,
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
                onChanged: (value) => setState(() {
                  _weightGoal = value;
                }),
              ),
              const SizedBox(height: 16),

              // Activity Level
              DropdownButtonFormField<ActivityLevel>(
                value: _activityLevel,
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
                onChanged: (value) => setState(() {
                  _activityLevel = value;
                }),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    metricsController.updateAllMetrics(
                      height: _height!,
                      weight: _weight!,
                      gender: _gender!,
                      birthday: _birthday!,
                      weightGoal: _weightGoal!,
                      activityLevel: _activityLevel!,
                    );

                    context.pushNamed(DashboardView.routeName);
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
