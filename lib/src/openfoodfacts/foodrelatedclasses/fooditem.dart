class FoodItem {
  final String name;
  final String barcode;
  final String? imageUrl;
  final String? ingredients;
  final String? allergens;
  final String? servingSize;
  final Map<String, double> nutritionInfo;
  double _grams;
  final List<Function> changeNotifiers = [];

  FoodItem({
    required this.name,
    required this.barcode,
    this.imageUrl,
    this.ingredients,
    this.allergens,
    this.servingSize,
    required this.nutritionInfo,
    double grams = 100,
  }) : _grams = grams;

  void addChangeNotifier(Function notifier) {
    changeNotifiers.add(notifier);
  }

  void notifyChange() {
    for (var notifier in changeNotifiers) {
      notifier();
    }
  }

  void setGrams(double grams) {
    this._grams = grams;
    notifyChange();
  }

  double get grams => _grams;

  // Factory constructor to create a FoodItem from JSON data
  factory FoodItem.fromFoodFactsJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};

    // TODO: Add validation for required fields

    return FoodItem(
      name: json['product_name'] ?? 'Unknown Product',
      barcode: json['code'] ?? 'No Barcode',
      imageUrl: json['image_url'],
      ingredients: json['ingredients_text'],
      allergens: json['allergens'],
      servingSize: json['serving_size'],
      nutritionInfo: {
        'calories': (nutriments['energy-kcal_100g'] ?? 0).toDouble(),
        'protein': (nutriments['proteins_100g'] ?? 0).toDouble(),
        'fat': (nutriments['fat_100g'] ?? 0).toDouble(),
        'sugars': (nutriments['sugars_100g'] ?? 0).toDouble(),
        'fiber': (nutriments['fiber_100g'] ?? 0).toDouble(),
        'carbs': (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
      },
      grams: json['grams'],
    );
  }

  // Method to convert FoodItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'allergens': allergens,
      'servingSize': servingSize,
      'nutritionInfo': nutritionInfo,
      'grams': _grams,
    };
  }

  // Factory constructor to create FoodItem from Firestore DocumentSnapshot
  factory FoodItem.fromJSON(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      barcode: json['barcode'],
      imageUrl: json['imageUrl'],
      ingredients: json['ingredients'],
      allergens: json['allergens'],
      servingSize: json['servingSize'],
      nutritionInfo: Map<String, double>.from(json['nutritionInfo']),
      grams: json['grams'],
    );
  }

  Map<String, double> calculateNutrition() {
    return {
      'calories': nutritionInfo['calories']! * _grams / 100,
      'protein': nutritionInfo['protein']! * _grams / 100,
      'fat': nutritionInfo['fat']! * _grams / 100,
      'sugars': nutritionInfo['sugars']! * _grams / 100,
      'fiber': nutritionInfo['fiber']! * _grams / 100,
      'carbs': nutritionInfo['carbs']! * _grams / 100,
    };
  }
}
