import 'package:fit_and_healthy/shared/models/activity_level.dart';

class CalorieCalculator {
  // TODO, add calculations for female and male
  // Different in intake, how much each burn and what is safe body fat %

  static double calculateCalories(
      double weight, double height, int age, ActivityLevel activityLevel) {
    double bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);

    return bmr * activityLevel.multiplier;
  }
}
