import 'package:cloud_firestore/cloud_firestore.dart';

enum NutritionInfoKey {
  calories,
  protein,
  fat,
  sugars,
  fiber,
  carbs,
}

extension NutritionInfoKeyExtension on NutritionInfoKey {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class FoodItem {
  final String? id;
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
    this.id,
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
        NutritionInfoKey.calories.name:
            (nutriments['energy-kcal_100g'] is String
                        ? double.tryParse(nutriments['energy-kcal_100g'])
                        : nutriments['energy-kcal_100g'])
                    ?.toDouble() ??
                0.0,
        NutritionInfoKey.protein.name: (nutriments['proteins_100g'] is String
                    ? double.tryParse(nutriments['proteins_100g'])
                    : nutriments['proteins_100g'])
                ?.toDouble() ??
            0.0,
        NutritionInfoKey.fat.name: (nutriments['fat_100g'] is String
                    ? double.tryParse(nutriments['fat_100g'])
                    : nutriments['fat_100g'])
                ?.toDouble() ??
            0.0,
        NutritionInfoKey.sugars.name: (nutriments['sugars_100g'] is String
                    ? double.tryParse(nutriments['sugars_100g'])
                    : nutriments['sugars_100g'])
                ?.toDouble() ??
            0.0,
        NutritionInfoKey.fiber.name: (nutriments['fiber_100g'] is String
                    ? double.tryParse(nutriments['fiber_100g'])
                    : nutriments['fiber_100g'])
                ?.toDouble() ??
            0.0,
        NutritionInfoKey.carbs.name: (nutriments['carbohydrates_100g'] is String
                    ? double.tryParse(nutriments['carbohydrates_100g'])
                    : nutriments['carbohydrates_100g'])
                ?.toDouble() ??
            0.0,
      },
      grams: 100,
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
      NutritionInfoKey.calories.name:
          nutritionInfo[NutritionInfoKey.calories.name]! * _grams / 100,
      NutritionInfoKey.protein.name:
          nutritionInfo[NutritionInfoKey.protein.name]! * _grams / 100,
      NutritionInfoKey.fat.name:
          nutritionInfo[NutritionInfoKey.fat.name]! * _grams / 100,
      NutritionInfoKey.sugars.name:
          nutritionInfo[NutritionInfoKey.sugars.name]! * _grams / 100,
      NutritionInfoKey.fiber.name:
          nutritionInfo[NutritionInfoKey.fiber.name]! * _grams / 100,
      NutritionInfoKey.carbs.name:
          nutritionInfo[NutritionInfoKey.carbs.name]! * _grams / 100,
    };
  }

  static Map<String, double> nutritionInfoFromDynamic(dynamic data) {
    if (data == null) {
      throw Exception('nutritionInfo data is! null');
    }

    if (data is Map<String, dynamic>) {
      return data.map((key, value) {
        if (NutritionInfoKey.values
                .map((e) => e.toShortString())
                .contains(key) &&
            value is num) {
          return MapEntry(key.toString(), value.toDouble());
        } else {
          throw Exception('Invalid nutritionInfo data');
        }
      });
    } else {
      throw Exception('Invalid nutritionInfo data');
    }
  }

  factory FoodItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Document data is null');
    }

    final name = data['name'];
    final barcode = data['barcode'];
    final imageUrl = data['imageUrl'];
    final ingredients = data['ingredients'];
    final allergens = data['allergens'];
    final servingSize = data['servingSize'];
    final grams = data['grams'];

    if (name != null && name is! String) {
      throw Exception('Invalid name');
    }

    if (barcode != null && barcode is! String) {
      throw Exception('Invalid barcode');
    }

    if (imageUrl != null && imageUrl is! String) {
      throw Exception('Invalid imageUrl');
    }

    if (ingredients != null && ingredients is! String) {
      throw Exception('Invalid ingredients');
    }

    if (allergens != null && allergens is! String) {
      throw Exception('Invalid allergens');
    }

    if (servingSize != null && servingSize is! String) {
      throw Exception('Invalid servingSize');
    }

    if (grams == null && (grams is! double || grams <= 0)) {
      throw Exception('Invalid grams');
    }

    final nutritionInfo = nutritionInfoFromDynamic(data['nutritionInfo']);

    return FoodItem(
      id: snapshot.id,
      name: name,
      barcode: barcode,
      imageUrl: imageUrl,
      ingredients: ingredients,
      allergens: allergens,
      servingSize: servingSize,
      nutritionInfo: nutritionInfo,
      grams: grams,
    );
  }

  Map<String, dynamic> toFirestore() {
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
}
