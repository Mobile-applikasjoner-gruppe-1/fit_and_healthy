enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  superActive,
}

extension ActivityLevelExtension on ActivityLevel {
  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary (little or no exercise)';
      case ActivityLevel.lightlyActive:
        return 'Lightly active (light exercise/sports 1-3 days/week)';
      case ActivityLevel.moderatelyActive:
        return 'Moderately active (moderate exercise/sports 3-5 days/week)';
      case ActivityLevel.veryActive:
        return 'Very active (hard exercise/sports 6-7 days a week)';
      case ActivityLevel.superActive:
        return 'Super active (very hard exercise & physical job)';
    }
  }

  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.superActive:
        return 1.9;
    }
  }
}
