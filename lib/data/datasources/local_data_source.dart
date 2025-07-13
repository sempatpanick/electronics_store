import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import 'helpers/database_helper.dart';

abstract class LocalDataSource {
  // Favorites
  Future<List<FavoriteEntity>> getFavorites();
  Future<FavoriteEntity> addFavorite(FavoriteEntity favorite);
  Future<void> removeFavorite(String productId);
  Future<bool> isFavorite(String productId);
  Future<void> clearFavorites();

  // Cart
  Future<List<CartEntity>> getCartItems();
  Future<CartEntity> addToCart(CartEntity cartItem);
  Future<CartEntity> updateCartItem(CartEntity cartItem);
  Future<void> removeFromCart(String productId);
  Future<void> removeCartItemById(String cartItemId);
  Future<void> clearCart();
  Future<CartEntity?> getCartItemByProductId(String productId);
  Future<CartEntity?> getCartItemById(String cartItemId);
}

class LocalDataSourceImpl implements LocalDataSource {
  LocalDataSourceImpl();

  // Favorites Implementation
  @override
  Future<List<FavoriteEntity>> getFavorites() async {
    try {
      final favorites = DatabaseHelper.favoriteBox.values.toList();
      return favorites.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<FavoriteEntity> addFavorite(FavoriteEntity favorite) async {
    try {
      final model = FavoriteModel.fromEntity(favorite);
      final key = DateTime.now().millisecondsSinceEpoch.toString();
      model.id = key;
      await DatabaseHelper.favoriteBox.put(key, model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String productId) async {
    try {
      final keysToRemove = <String>[];
      final allKeys = DatabaseHelper.favoriteBox.keys.cast<String>();

      for (final key in allKeys) {
        final favorite = DatabaseHelper.favoriteBox.get(key);
        if (favorite?.productId == productId) {
          keysToRemove.add(key);
        }
      }

      await DatabaseHelper.favoriteBox.deleteAll(keysToRemove);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    try {
      final favorites = DatabaseHelper.favoriteBox.values.toList();

      for (final favorite in favorites) {
        if (favorite.productId == productId) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await DatabaseHelper.favoriteBox.clear();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }

  // Cart Implementation
  @override
  Future<List<CartEntity>> getCartItems() async {
    try {
      final cartItems = DatabaseHelper.cartBox.values.toList();
      return cartItems.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CartEntity> addToCart(CartEntity cartItem) async {
    try {
      final model = CartModel.fromEntity(cartItem);
      final key = DateTime.now().millisecondsSinceEpoch.toString();
      model.id = key;
      await DatabaseHelper.cartBox.put(key, model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  @override
  Future<CartEntity> updateCartItem(CartEntity cartItem) async {
    try {
      final model = CartModel.fromEntity(cartItem);
      await DatabaseHelper.cartBox.put(cartItem.id, model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    try {
      final keysToRemove = <String>[];
      final allKeys = DatabaseHelper.cartBox.keys.cast<String>();

      for (final key in allKeys) {
        final cartItem = DatabaseHelper.cartBox.get(key);
        if (cartItem?.productId == productId) {
          keysToRemove.add(key);
        }
      }

      await DatabaseHelper.cartBox.deleteAll(keysToRemove);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  @override
  Future<void> removeCartItemById(String cartItemId) async {
    try {
      await DatabaseHelper.cartBox.delete(cartItemId);
    } catch (e) {
      throw Exception('Failed to remove cart item by ID: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await DatabaseHelper.cartBox.clear();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Future<CartEntity?> getCartItemByProductId(String productId) async {
    try {
      for (final cartItem in DatabaseHelper.cartBox.values) {
        if (cartItem.productId == productId) {
          return cartItem.toEntity();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<CartEntity?> getCartItemById(String cartItemId) async {
    try {
      final cartItem = DatabaseHelper.cartBox.get(cartItemId);
      return cartItem?.toEntity();
    } catch (e) {
      return null;
    }
  }
}
