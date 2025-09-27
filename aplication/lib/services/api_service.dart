import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Base URL Fake Store API
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts({int limit = 10, int? offset}) async {
    final url = Uri.parse('$baseUrl/products');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List<dynamic> list = json.decode(res.body);
      final products = list.map((e) => Product.fromJson(e)).toList();
      return products;
    } else {
      throw Exception('Error fetching products: ${res.statusCode}');
    }
  }

  Future<Product> getProduct(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return Product.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error getting product: ${res.statusCode}');
    }
  }

  Future<Product> createProduct(Product product) async {
    final url = Uri.parse('$baseUrl/products');
    final res = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Product.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error creating product: ${res.statusCode}');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    final url = Uri.parse('$baseUrl/products/$id');
    final res = await http.put(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (res.statusCode == 200) {
      return Product.fromJson(json.decode(res.body));
    } else {
      throw Exception('Error updating product: ${res.statusCode}');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');
    final res = await http.delete(url);
    return res.statusCode == 200;
  }
}
