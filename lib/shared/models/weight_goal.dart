enum WeightGoal {
  gain,
  maintain,
  lose,
}

// Extension for descriptions
extension WeightGoalDescription on WeightGoal {
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
}
