import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:flutter/material.dart';
import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';

class GoalsSettingsPage extends StatefulWidget {
  static const routeName = '/goals';

  _GoalsSettingsPage createState() => _GoalsSettingsPage();
}

class _GoalsSettingsPage extends State<GoalsSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  ActivityLevel? _selectedActivityLevel;
  double? _caloriesNeeded;

  void _calculatedCalories() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.tryParse(_weightController.text) ?? 0;
      final height = double.tryParse(_heightController.text) ?? 0;
      final age = int.parse(_ageController.text);
      if (_selectedActivityLevel != null) {
        final calories = CalorieCalculator.calculateCalories(
            weight, height, age, _selectedActivityLevel!);
        setState(() {
          _caloriesNeeded = calories;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goals"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weigth (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              //TODO dateTimePicker? since people age xd
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<ActivityLevel>(
                value: _selectedActivityLevel,
                isExpanded: true,
                items: ActivityLevel.values.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level.description),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivityLevel = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Activity Level',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Please select an activity level' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculatedCalories,
                child: Text('Calculate Calories'),
              ),
              SizedBox(height: 24),
              if (_caloriesNeeded != null)
                Text(
                    'You need approximately ${_caloriesNeeded!.toStringAsFixed(0)} calories per day.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
