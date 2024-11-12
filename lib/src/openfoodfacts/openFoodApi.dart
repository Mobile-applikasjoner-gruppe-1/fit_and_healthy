import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenFoodApi {
  final String baseUrl;

  OpenFoodApi({this.baseUrl = 'https://world.openfoodfacts.org'});

  // Search products by name specific to Norway
  Future<List<Map<String, dynamic>>> searchProductsByName(String query) async {
    final url = Uri.parse(
        '$baseUrl/cgi/search.pl?search_terms=$query&search_simple=1&json=1&country=NO');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'] as List;
      return products
          .map((product) => product as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  // Fetch product by barcode
  Future<Map<String, dynamic>?> fetchProductByBarcode(String barcode) async {
    final url = Uri.parse('$baseUrl/api/v0/product/$barcode.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        return data['product'];
      } else {
        return null; // Product not found
      }
    } else {
      throw Exception('Failed to load product');
    }
  }
}
