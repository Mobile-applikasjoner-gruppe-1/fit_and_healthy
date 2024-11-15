import 'package:flutter/material.dart';

class GoalsSettingsPage extends StatefulWidget {
  static const routeName = '/goals';

  _GoalsSettingsPage createState() => _GoalsSettingsPage();
}

class _GoalsSettingsPage extends State<GoalsSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedActivityLevel;
  double? _caloriesNeeded;
  // TODO, add calculations for female and male

  final List<String> _activityLevels = [
    'Sedentary (little or no exercise)',
    'Lightly active (light exercise/sports 1-3 days/week)',
    'Moderately active (moderate exercise/sports 3-5 days/week)',
    'Very active (hard exercise/sports 6-7 days a week)',
    'Super active (very hard exercise & physical job)',
  ];

  double calculateCalories(
      double weight, double height, int age, String activityLevel) {
    double bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    double activityMultiplier;
    switch (activityLevel) {
      case 'Sedentary (little or no exercise)':
        activityMultiplier = 1.2;
        break;
      case 'Lightly active (light exercise/sports 1-3 days/week)':
        activityMultiplier = 1.375;
        break;
      case 'Moderately active (moderate exercise/sports 3-5 days/week)':
        activityMultiplier = 1.55;
        break;
      case 'Very active (hard exercise/sports 6-7 days a week)':
        activityMultiplier = 1.725;
        break;
      case 'Super active (very hard exercise & physical job)':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }

    return bmr * activityMultiplier;
  }

  void _calculatedCalories() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.tryParse(_weightController.text) ?? 0;
      final height = double.tryParse(_heightController.text) ?? 0;
      final age = int.parse(_ageController.text);
      if (_selectedActivityLevel != null) {
        final calories =
            calculateCalories(weight, height, age, _selectedActivityLevel!);
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
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                isExpanded: true,
                items: _activityLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
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
