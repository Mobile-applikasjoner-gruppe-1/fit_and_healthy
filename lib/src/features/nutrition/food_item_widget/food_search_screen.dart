// FoodSearchScreen.dart
import 'package:fit_and_healthy/src/features/nutrition/data/open_food_api.dart';
import 'package:fit_and_healthy/src/features/nutrition/food_item_widget/food_item_widget.dart';
import 'package:fit_and_healthy/src/features/nutrition/meal_item/food_item.dart';
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FoodSearchScreen extends StatefulWidget {
  static const route = '/search';
  static const routeName = 'Nutrition Search';

  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final List<FoodItem> foodItems = []; // List of added food items
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _searchResults = []; // Store search results

  // Method to search for products
  Future<void> _searchProducts(String query) async {
    final api = OpenFoodApi();
    final results = await api.searchProductsByName(query);
    setState(() {
      _searchResults =
          results.map((json) => FoodItem.fromFoodFactsJson(json)).toList();
    });
  }

  // Method to fetch product by barcode and add to search results
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

  // Method to add food item to the list
  void _addFoodItem(FoodItem item) {
    setState(() {
      foodItems.add(item);
      _searchResults.clear(); // Clear search results after adding
      _searchController.clear(); // Clear search input
    });
  }

  // Method to show a message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Method to show the barcode scanner and handle the result
  Future<void> _scanBarcode() async {
    String barcode = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Scan Barcode'),
              content: SizedBox(
                height: 400,
                width: 300,
                child: MobileScanner(
                  onDetect: (BarcodeCapture barcodeCapture) {
                    final String barcodeValue =
                        barcodeCapture.barcodes.isNotEmpty
                            ? barcodeCapture.barcodes.first.rawValue ?? ''
                            : '';
                    Navigator.pop(context, barcodeValue);
                  },
                ),
              ),
            );
          },
        ) ??
        ''; // If no barcode is scanned, return an empty string

    if (barcode.isNotEmpty) {
      await _searchProductByBarcode(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScaffold(
      appBar: AppBar(
        title: Text('Search Products'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'Search Results',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.barcode),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addFoodItem(item),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Added Items',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return FoodItemWidget(foodItem: foodItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
