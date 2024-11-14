import 'package:fit_and_healthy/src/openfoodfacts/foodrelatedclasses/fooditem.dart';
import 'package:flutter/material.dart';

/// food widget that shows the product
class FoodItemWidget extends StatelessWidget {
  final FoodItem foodItem;

  FoodItemWidget({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image of the food item
            if (foodItem.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  foodItem.imageUrl!,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            SizedBox(height: 16.0),
            // Display the name and barcode
            Text(
              foodItem.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.0),
            Text(
              'Barcode: ${foodItem.barcode}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.0),
            // Display ingredients, allergens, and serving size
            if (foodItem.ingredients != null)
              Text(
                'Ingredients: ${foodItem.ingredients}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (foodItem.allergens != null)
              Text(
                'Allergens: ${foodItem.allergens}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (foodItem.servingSize != null)
              Text(
                'Serving Size: ${foodItem.servingSize}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            SizedBox(height: 16.0),
            // Display nutrition information
            Text(
              'Nutrition Information:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0),
            ...foodItem.nutritionInfo.entries.map((entry) {
              return Text(
                '${entry.key.capitalize()}: ${entry.value.toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of the nutrition keys
extension StringCapitalization on String {
  String capitalize() {
    if (this.isEmpty) return '';
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
