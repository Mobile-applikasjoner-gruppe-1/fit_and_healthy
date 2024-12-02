/// A model representing the results of a calorie and macronutrient calculation.
///
/// This model contains the Basal Metabolic Rate (BMR), total calorie needs,
/// and recommended macronutrient distributions for protein, fats, and carbohydrates.
class CalorieCalculatorModel {
  final double bmr;
  final double totalCalorie;
  final double recommendedProtein;
  final double recommendedFats;
  final double recommendedCarbs;

  CalorieCalculatorModel({
    required this.bmr,
    required this.totalCalorie,
    required this.recommendedProtein,
    required this.recommendedFats,
    required this.recommendedCarbs,
  });
}
