import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/utils/calorie_calculator.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:fit_and_healthy/src/features/metrics/metrics_controller.dart';

/// This page allows users to manage their fitness goals, including:
/// - Setting a weekly workout goal
/// - Setting a weight goal
/// - Calculating daily calorie needs based on personal metrics
class GoalsSettingsPage extends ConsumerStatefulWidget {
  static const route = '/goals';
  static const routeName = 'Goals Settings';

  @override
  _GoalsSettingsPageState createState() => _GoalsSettingsPageState();
}

class _GoalsSettingsPageState extends ConsumerState<GoalsSettingsPage> {
  double? _caloriesNeeded;

  @override
  Widget build(BuildContext context) {
    final metricsState = ref.watch(metricsControllerProvider);

    final data = metricsState.value;

    if (data == null) {
      return const Center(child: Text('No data available.'));
    }

    //TODO: get the latest weight
    final weigth = data.weightHistory.last;
    final height = data.height;
    final birthday = data.birthday;
    final gender = data.gender;
    final activityLevel = data.activityLevel;
    final weightGoal = data.weightGoal;
    final weeklyWorkoutGoal = data.weeklyWorkoutGoal;

    final description = weightGoal.description;

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
              _buildWorkoutGoalOption(context, ref, weeklyWorkoutGoal),
              const Divider(height: 1, thickness: 1),
              _buildOption(
                context,
                title: 'Weight Goal',
                subtitle: description,
                trailingValue: description,
                onTap: () {
                  _showWeightGoalDialog(context, ref, weightGoal);
                },
              ),
              const Divider(height: 1, thickness: 1),
              _buildOption(
                context,
                title: 'Calculate Calories',
                subtitle: _caloriesNeeded != null
                    ? '${_caloriesNeeded!.toStringAsFixed(0)} calories needed per day'
                    : 'Get your daily calorie requirement',
                onTap: () {
                  _showCalorieCalculatorModal(height, weigth.weight, birthday,
                      gender, activityLevel, weightGoal);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the workout goal option with a tap handler for setting a new goal.
  Widget _buildWorkoutGoalOption(
      BuildContext context, WidgetRef ref, int weeklyWorkoutGoal) {
    final theme = Theme.of(context);

    return ListTile(
      title: const Text('Weekly Workout Goal'),
      subtitle: const Text('Set your weekly workout goal.'),
      trailing: Text(
        '$weeklyWorkoutGoal/week',
        style: theme.textTheme.bodyLarge,
      ),
      onTap: () {
        _showWorkoutGoalPopup(context, ref, weeklyWorkoutGoal);
      },
    );
  }

  /// Builds a reusable option tile with a tap handler.
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

  /// Displays a popup for setting a new weekly workout goal.
  void _showWorkoutGoalPopup(
      BuildContext context, WidgetRef ref, int weeklyWorkoutGoal) {
    final TextEditingController workoutController =
        TextEditingController(text: weeklyWorkoutGoal.toString());

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
                final int? newGoal = int.tryParse(workoutController.text);
                if (newGoal != null) {
                  ref
                      .read(metricsControllerProvider.notifier)
                      .updateWeeklyWorkoutGoal(newGoal);
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

  /// Displays a dialog for setting a weight goal.
  void _showWeightGoalDialog(
      BuildContext context, WidgetRef ref, WeightGoal currentGoal) {
    showDialog(
      context: context,
      builder: (context) {
        WeightGoal? selectedGoal = currentGoal;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Weight Goal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: WeightGoal.values.map((goal) {
                  return RadioListTile<WeightGoal>(
                    title: Text(goal.description),
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
                    if (selectedGoal != null) {
                      ref
                          .read(metricsControllerProvider.notifier)
                          .updateWeightGoal(selectedGoal!);
                    }
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

  /// Displays a modal for calculating daily calorie needs.
  void _showCalorieCalculatorModal(
    double height,
    double weight,
    DateTime? birthday,
    Gender gender,
    ActivityLevel activityLevel,
    WeightGoal weighGoal,
  ) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController heightController =
        TextEditingController(text: height.toString());
    final TextEditingController birthdayController = TextEditingController();

    late final TextEditingController weightController =
        TextEditingController(text: weight.toString());
    ActivityLevel? selectedActivityLevel = activityLevel;

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
                      controller: weightController,
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

                            if (birthday == null &&
                                birthdayController.text.isNotEmpty) {
                              final parts = birthdayController.text.split('/');
                              final newBirthday = DateTime(
                                int.parse(parts[2]),
                                int.parse(parts[1]),
                                int.parse(parts[0]),
                              );
                              await ref
                                  .read(metricsControllerProvider.notifier)
                                  .setBirthday(newBirthday);
                            }

                            if (!height.isNaN) {
                              await ref
                                  .read(metricsControllerProvider.notifier)
                                  .updateHeight(height);
                            }

                            if (selectedActivityLevel != null) {
                              await ref
                                  .read(metricsControllerProvider.notifier)
                                  .addWeight(weight);
                              await ref
                                  .read(metricsControllerProvider.notifier)
                                  .updateActivityLevel(selectedActivityLevel!);
                              final calories =
                                  CalorieCalculator.calculateCalories(
                                weight: weight,
                                height: height,
                                birthday: birthday!,
                                activityLevel: ActivityLevel.moderatelyActive,
                                gender: Gender.male,
                                weightGoal: WeightGoal.maintain,
                              );
                              setState(() {
                                _caloriesNeeded = calories.totalCalorie;
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

  /// Builds a text field with validation.
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
