import 'package:dartz/dartz.dart';
import '../entities/cart_entity.dart';
import '../entities/favorite_entity.dart';
import '../entities/product_entity.dart';

abstract class AppRepository {
  // Favorites
  Future<Either<String, List<FavoriteEntity>>> getFavorites();
  Future<Either<String, FavoriteEntity>> addFavorite(FavoriteEntity favorite);
  Future<Either<String, void>> removeFavorite(String productId);
  Future<Either<String, bool>> isFavorite(String productId);
  Future<Either<String, void>> clearFavorites();

  // Cart
  Future<Either<String, List<CartEntity>>> getCartItems();
  Future<Either<String, CartEntity>> addToCart(CartEntity cartItem);
  Future<Either<String, CartEntity>> updateCartItem(CartEntity cartItem);
  Future<Either<String, void>> removeFromCart(String productId);
  Future<Either<String, void>> removeCartItemById(String cartItemId);
  Future<Either<String, void>> clearCart();
  Future<Either<String, CartEntity?>> getCartItemByProductId(String productId);
  Future<Either<String, CartEntity?>> getCartItemById(String cartItemId);

  // Products
  Future<Either<String, List<ProductEntity>>> getProducts();
  Future<Either<String, ProductEntity?>> getProductById(String productId);
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
    String category,
  );
  Future<Either<String, List<ProductEntity>>> searchProducts(String query);
  Future<Either<String, List<String>>> getCategories();
}
