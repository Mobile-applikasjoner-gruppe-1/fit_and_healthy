import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:fit_and_healthy/src/features/settings/metrics_controller.dart';

class GoalsSettingsPage extends ConsumerStatefulWidget {
  static const route = '/goals';
  static const routeName = 'Goals Settings';

  @override
  _GoalsSettingsPageState createState() => _GoalsSettingsPageState();
}

class _GoalsSettingsPageState extends ConsumerState<GoalsSettingsPage> {
  int _weeklyWorkoutGoal = 3; // Default value
  String? _weightGoal;
  double? _caloriesNeeded;

  final List<String> _weightGoals = [
    'Gain Weight',
    'Maintain Weight',
    'Lose Weight',
  ];

  late final TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController();
    _loadUserWeight();
  }

  Future<void> _loadUserWeight() async {
    final latestWeight =
        await ref.read(metricsControllerProvider.notifier).getLatestWeight();
    if (latestWeight != null) {
      setState(() {
        weightController.text =
            latestWeight.toString(); // Pre-fill the text field
      });
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: const Text("Goals"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Column(
            children: [
              _buildWorkoutGoalOption(context),
              const Divider(height: 1, thickness: 1),
              _buildOption(
                context,
                title: 'Weight Goal',
                subtitle: _weightGoal ?? 'Set your weight goal',
                trailingValue: _weightGoal,
                onTap: _showWeightGoalDialog,
              ),
              const Divider(height: 1, thickness: 1),
              _buildOption(
                context,
                title: 'Calculate Calories',
                subtitle: _caloriesNeeded != null
                    ? '${_caloriesNeeded!.toStringAsFixed(0)} calories needed per day'
                    : 'Get your daily calorie requirement',
                onTap: _showCalorieCalculatorModal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutGoalOption(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: const Text('Weekly Workout Goal'),
      subtitle: const Text('Set your weekly workout goal.'),
      trailing: Text(
        '$_weeklyWorkoutGoal/week',
        style: theme.textTheme.bodyLarge,
      ),
      onTap: _showWorkoutGoalPopup,
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? trailingValue,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingValue != null)
            Text(
              trailingValue,
              style: theme.textTheme.bodyLarge,
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showWorkoutGoalPopup() {
    final TextEditingController workoutController =
        TextEditingController(text: _weeklyWorkoutGoal.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Weekly Workout Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'For optimal results, aim for 3-5 workouts per week, depending on your fitness level and goals.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: workoutController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter number of workouts',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? enteredGoal = int.tryParse(workoutController.text);
                if (enteredGoal != null) {
                  setState(() {
                    _weeklyWorkoutGoal = enteredGoal;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showWeightGoalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedGoal = _weightGoal;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Weight Goal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: _weightGoals.map((goal) {
                  return RadioListTile<String>(
                    title: Text(goal),
                    value: goal,
                    groupValue: selectedGoal,
                    onChanged: (value) {
                      setState(() {
                        selectedGoal = value;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.setState(() {
                      _weightGoal = selectedGoal;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCalorieCalculatorModal() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController heightController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    ActivityLevel? selectedActivityLevel;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Text('Calculate Daily Calorie Needs'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller:
                          weightController, // Pre-filled weight controller
                      labelText: 'Weight (kg)',
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
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: heightController,
                      labelText: 'Height (cm)',
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
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: ageController,
                      labelText: 'Age',
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
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ActivityLevel>(
                      value: selectedActivityLevel,
                      isExpanded: true,
                      items: ActivityLevel.values.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level.description),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedActivityLevel = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Activity Level',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null
                          ? 'Please select an activity level'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final weight =
                                double.tryParse(weightController.text) ?? 0;
                            final height =
                                double.tryParse(heightController.text) ?? 0;
                            final age = int.parse(ageController.text);
                            if (selectedActivityLevel != null) {
                              await ref
                                  .read(metricsControllerProvider.notifier)
                                  .addWeight(weight);
                              final calories =
                                  CalorieCalculator.calculateCalories(
                                weight,
                                height,
                                age,
                                selectedActivityLevel!,
                              );
                              setState(() {
                                _caloriesNeeded = calories;
                              });
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: const Text('Calculate'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
