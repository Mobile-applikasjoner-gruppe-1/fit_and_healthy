class FoodItem {
  final String name;
  final String barcode;
  final String? imageUrl;
  final String? ingredients;
  final String? allergens;
  final String? servingSize;
  final Map<String, double> nutritionInfo;

  FoodItem({
    required this.name,
    required this.barcode,
    this.imageUrl,
    this.ingredients,
    this.allergens,
    this.servingSize,
    required this.nutritionInfo,
  });

  // Factory constructor to create a FoodItem from JSON data
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};
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
    };
  }

  // Factory constructor to create FoodItem from Firestore DocumentSnapshot
  factory FoodItem.fromFirestore(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      barcode: json['barcode'],
      imageUrl: json['imageUrl'],
      ingredients: json['ingredients'],
      allergens: json['allergens'],
      servingSize: json['servingSize'],
      nutritionInfo: Map<String, double>.from(json['nutritionInfo']),
    );
  }
}
