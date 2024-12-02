import 'package:fit_and_healthy/src/features/nutrition/data/open_food_api.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/widgets/barcode_scanner_widget.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal/widgets/food_item_widget.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:flutter/material.dart';

class FoodItemSearch extends StatefulWidget {
  final Function(FoodItem) onFoodItemAdded;

  const FoodItemSearch({super.key, required this.onFoodItemAdded});

  @override
  _FoodItemSearchState createState() => _FoodItemSearchState();
}

class _FoodItemSearchState extends State<FoodItemSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _searchResults = []; // Search results

  // Search by product name
  Future<void> _searchProducts(String query) async {
    final api = OpenFoodApi();
    final results = await api.searchProductsByName(query);
    setState(() {
      _searchResults = results
          .take(3)
          .map((json) => FoodItem.fromFoodFactsJson(json))
          .toList();
    });
  }

  // Search by barcode
  Future<void> _searchProductByBarcode(String barcode) async {
    final api = OpenFoodApi();
    try {
      final product = await api.fetchProductByBarcode(barcode);
      if (product != null) {
        setState(() {
          _searchResults = [FoodItem.fromFoodFactsJson(product)];
        });
      } else {
        _showMessage('Product not found for barcode: $barcode');
      }
    } catch (e) {
      _showMessage('Failed to fetch product: $e');
    }
  }

  // Add a food item to the list
  void _addFoodItem(FoodItem item) {
    setState(() {
      widget.onFoodItemAdded(item);
      _searchResults.clear();
      _searchController.clear();
    });
  }

  // Show barcode scanner
  Future<void> _scanBarcode() async {
    String? barcode = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return BarcodeScannerDialog(); // Updated for better naming
      },
    );
    if (barcode != null && barcode.isNotEmpty) {
      await _searchProductByBarcode(barcode);
    }
  }

  // Show a message to the user
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Input
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Enter product name or barcode',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchProducts(_searchController.text);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _scanBarcode,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        if (_searchResults.isEmpty)
          Center(
              child: Text(
            'No search results',
            style: Theme.of(context).textTheme.bodyLarge,
          ))
        else ...[
          Text(
            'Search Results',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final item = _searchResults[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.barcode),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () => showFoodItemInfoDialog(context, item),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addFoodItem(item),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
