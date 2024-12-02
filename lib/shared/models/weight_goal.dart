// Enum representing weight management goals.
///
/// Goals:
/// - [gain]: Gain weight.
/// - [maintain]: Maintain current weight.
/// - [lose]: Lose weight.
enum WeightGoal {
  gain,
  maintain,
  lose,
}

/// Extension for [WeightGoal] to add utility methods and descriptions.
extension WeightGoalExtension on WeightGoal {
  String get description {
    switch (this) {
      case WeightGoal.gain:
        return 'Gain Weight';
      case WeightGoal.maintain:
        return 'Maintain Weight';
      case WeightGoal.lose:
        return 'Lose Weight';
    }
  }

  static String toFirestore(WeightGoal weightGoal) {
    return weightGoal.toString().split('.').last;
  }

  static WeightGoal fromFirestore(String weightGoal) {
    return WeightGoal.values.firstWhere(
      (w) => w.toString() == 'WeightGoal.${weightGoal}',
      orElse: () => WeightGoal.maintain,
    );
  }
}
