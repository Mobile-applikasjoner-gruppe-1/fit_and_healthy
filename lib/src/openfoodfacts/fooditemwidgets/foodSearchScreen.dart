// FoodSearchScreen.dart
import 'package:fit_and_healthy/src/nested_scaffold.dart';
import 'package:flutter/material.dart';

import '../foodrelatedclasses/fooditem.dart';
import '../openFoodApi.dart';
import 'fooditemwidget.dart';

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
    final api = OpenFoodApi(); // Assuming you have the API set up
    final results = await api.searchProductsByName(query);
    setState(() {
      _searchResults = results.map((json) => FoodItem.fromJson(json)).toList();
    });
  }

  // Method to add food item to the list
  void _addFoodItem(FoodItem item) {
    setState(() {
      foodItems.add(item);
      _searchResults.clear(); // Clear search results after adding
      _searchController.clear(); // Clear search input
    });
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchProducts(_searchController.text);
                  },
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
