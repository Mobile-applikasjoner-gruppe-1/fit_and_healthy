import 'package:fit_and_healthy/shared/models/activity_level.dart';
import 'package:fit_and_healthy/shared/models/calorie_calculator_model.dart';
import 'package:fit_and_healthy/shared/models/gender.dart';
import 'package:fit_and_healthy/shared/models/weight_goal.dart';

class CalorieCalculator {
  static CalorieCalculatorModel calculateCalories({
    required double weight,
    required double height,
    required DateTime birthday,
    required ActivityLevel activityLevel,
    required Gender gender,
    required WeightGoal weightGoal,
  }) {
    int age = _calculateAge(birthday);
    double bmr = gender == Gender.male
        ? 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        : 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);

    double bmrAl = bmr * activityLevel.multiplier;

    double totalCalories;
    switch (weightGoal) {
      case WeightGoal.gain:
        totalCalories = bmrAl + 500;
        break;
      case WeightGoal.lose:
        totalCalories = bmrAl - 500;
        break;
      default:
        totalCalories = bmrAl;
    }

    double recommendedProtein = weight * 2;
    double recommendedFats = (totalCalories * 0.25) / 9;
    double recommendedCarbs =
        ((totalCalories - (recommendedProtein * 4) - (recommendedFats * 9)) /
            4);

    return CalorieCalculatorModel(
      bmr: bmr,
      totalCalorie: totalCalories,
      recommendedProtein: recommendedProtein,
      recommendedFats: recommendedFats,
      recommendedCarbs: recommendedCarbs,
    );
  }

  static int _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }
}
