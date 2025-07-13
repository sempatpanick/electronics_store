import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../repositories/app_repository.dart';

class ProductUseCase {
  final AppRepository _repository;

  ProductUseCase(this._repository);

  // Get all products
  Future<Either<String, List<ProductEntity>>> getProducts() {
    return _repository.getProducts();
  }

  // Get product by ID
  Future<Either<String, ProductEntity?>> getProductById(String productId) {
    return _repository.getProductById(productId);
  }

  // Get products by category
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
      String category) {
    return _repository.getProductsByCategory(category);
  }

  // Search products
  Future<Either<String, List<ProductEntity>>> searchProducts(String query) {
    return _repository.searchProducts(query);
  }

  // Get all categories
  Future<Either<String, List<String>>> getCategories() {
    return _repository.getCategories();
  }

  // Get filtered products (by category and search)
  Future<Either<String, List<ProductEntity>>> getFilteredProducts({
    String? category,
    String? searchQuery,
  }) async {
    try {
      List<ProductEntity> products;

      // First filter by category
      if (category != null && category != 'All') {
        final categoryResult =
            await _repository.getProductsByCategory(category);
        products = categoryResult.fold(
          (error) => throw Exception(error),
          (categoryProducts) => categoryProducts,
        );
      } else {
        final allProductsResult = await _repository.getProducts();
        products = allProductsResult.fold(
          (error) => throw Exception(error),
          (allProducts) => allProducts,
        );
      }

      // Then filter by search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchResult = await _repository.searchProducts(searchQuery);
        final searchProducts = searchResult.fold(
          (error) => throw Exception(error),
          (searchedProducts) => searchedProducts,
        );

        // Apply category filter to search results if category is specified
        if (category != null && category != 'All') {
          products = searchProducts
              .where((product) => product.category == category)
              .toList();
        } else {
          products = searchProducts;
        }
      }

      return Right(products);
    } catch (e) {
      return Left('Failed to get filtered products: $e');
    }
  }
}
