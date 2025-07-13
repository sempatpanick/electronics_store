import 'package:dartz/dartz.dart';

import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/app_repository.dart';
import '../datasources/assets_data_source.dart';
import '../datasources/local_data_source.dart';

class AppRepositoryImpl implements AppRepository {
  final LocalDataSource _localDataSource;
  final AssetsDataSource _assetsDataSource;

  AppRepositoryImpl(this._localDataSource, this._assetsDataSource);

  // Favorites Implementation
  @override
  Future<Either<String, List<FavoriteEntity>>> getFavorites() async {
    try {
      final favorites = await _localDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left('Failed to get favorites: $e');
    }
  }

  @override
  Future<Either<String, FavoriteEntity>> addFavorite(
    FavoriteEntity favorite,
  ) async {
    try {
      final result = await _localDataSource.addFavorite(favorite);
      return Right(result);
    } catch (e) {
      return Left('Failed to add favorite: $e');
    }
  }

  @override
  Future<Either<String, void>> removeFavorite(String productId) async {
    try {
      await _localDataSource.removeFavorite(productId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to remove favorite: $e');
    }
  }

  @override
  Future<Either<String, bool>> isFavorite(String productId) async {
    try {
      final result = await _localDataSource.isFavorite(productId);
      return Right(result);
    } catch (e) {
      return Left('Failed to check favorite status: $e');
    }
  }

  @override
  Future<Either<String, void>> clearFavorites() async {
    try {
      await _localDataSource.clearFavorites();
      return const Right(null);
    } catch (e) {
      return Left('Failed to clear favorites: $e');
    }
  }

  // Cart Implementation
  @override
  Future<Either<String, List<CartEntity>>> getCartItems() async {
    try {
      final cartItems = await _localDataSource.getCartItems();
      return Right(cartItems);
    } catch (e) {
      return Left('Failed to get cart items: $e');
    }
  }

  @override
  Future<Either<String, CartEntity>> addToCart(CartEntity cartItem) async {
    try {
      final result = await _localDataSource.addToCart(cartItem);
      return Right(result);
    } catch (e) {
      return Left('Failed to add to cart: $e');
    }
  }

  @override
  Future<Either<String, CartEntity>> updateCartItem(CartEntity cartItem) async {
    try {
      final result = await _localDataSource.updateCartItem(cartItem);
      return Right(result);
    } catch (e) {
      return Left('Failed to update cart item: $e');
    }
  }

  @override
  Future<Either<String, void>> removeFromCart(String productId) async {
    try {
      await _localDataSource.removeFromCart(productId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to remove from cart: $e');
    }
  }

  @override
  Future<Either<String, void>> clearCart() async {
    try {
      await _localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left('Failed to clear cart: $e');
    }
  }

  @override
  Future<Either<String, CartEntity?>> getCartItemByProductId(
    String productId,
  ) async {
    try {
      final result = await _localDataSource.getCartItemByProductId(productId);
      return Right(result);
    } catch (e) {
      return Left('Failed to get cart item: $e');
    }
  }

  // Products Implementation
  @override
  Future<Either<String, List<ProductEntity>>> getProducts() async {
    try {
      final productModels = await _assetsDataSource.getProducts();
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left('Failed to get products: $e');
    }
  }

  @override
  Future<Either<String, ProductEntity?>> getProductById(
      String productId) async {
    try {
      final productModel = await _assetsDataSource.getProductById(productId);
      final product = productModel?.toEntity();
      return Right(product);
    } catch (e) {
      return Left('Failed to get product: $e');
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
      String category) async {
    try {
      final productModels =
          await _assetsDataSource.getProductsByCategory(category);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left('Failed to get products by category: $e');
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> searchProducts(
      String query) async {
    try {
      final productModels = await _assetsDataSource.searchProducts(query);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left('Failed to search products: $e');
    }
  }

  @override
  Future<Either<String, List<String>>> getCategories() async {
    try {
      final categories = await _assetsDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left('Failed to get categories: $e');
    }
  }
}
