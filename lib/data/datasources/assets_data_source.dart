import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product_model.dart';

abstract class AssetsDataSource {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel?> getProductById(String productId);

  Future<List<ProductModel>> getProductsByCategory(String category);

  Future<List<ProductModel>> searchProducts(String query);

  Future<List<String>> getCategories();
}

class AssetsDataSourceImpl implements AssetsDataSource {
  static List<ProductModel>? _products;

  @override
  Future<List<ProductModel>> getProducts() async {
    if (_products != null) {
      return _products!;
    }

    try {
    final String response =
        await rootBundle.loadString('assets/json/products.json');
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    _products = data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
    return _products!;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String productId) async {
    final products = await getProducts();
    try {
      return products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final products = await getProducts();
    if (category == 'All') {
      return products;
    }
    return products.where((product) => product.category == category).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await getProducts();
    if (query.isEmpty) {
      return products;
    }

    final lowercaseQuery = query.toLowerCase();
    return products.where((product) {
      final name = product.name.toLowerCase();
      final brand = product.brand.toLowerCase();
      return name.contains(lowercaseQuery) || brand.contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final products = await getProducts();
    final categories =
        products.map((product) => product.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }
}
