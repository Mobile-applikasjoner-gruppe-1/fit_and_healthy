import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';

class CalorieCalculator {
  // TODO, add calculations for female and male
  // Different in intake, how much each burn and what is safe body fat %

  static double calculateCalories(
    double weight,
    double height,
    int age,
    ActivityLevel activityLevel,
    Gender gender,
    WeightGoal weightGoal,
  ) {
    double bmr = gender == Gender.male
        ? 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        : 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);

    double bmrAl = bmr * activityLevel.multiplier;

    switch (weightGoal) {
      case WeightGoal.gain:
        return bmrAl + 500;
      case WeightGoal.lose:
        return bmrAl - 500;
      default:
        return bmrAl;
    }
  }
}
