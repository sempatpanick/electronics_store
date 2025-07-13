import 'package:dartz/dartz.dart';
import '../entities/cart_entity.dart';
import '../entities/product_entity.dart';
import '../repositories/app_repository.dart';

class CartUseCase {
  final AppRepository _repository;

  CartUseCase(this._repository);

  // Get all cart items
  Future<Either<String, List<CartEntity>>> getCartItems() {
    return _repository.getCartItems();
  }

  // Generate a unique key for cart item based on product ID and selected options
  String _generateCartItemKey(
    String productId, {
    String? selectedVariant,
    String? selectedColor,
    String? selectedRam,
    String? selectedStorage,
  }) {
    final options = [
      selectedVariant ?? '',
      selectedColor ?? '',
      selectedRam ?? '',
      selectedStorage ?? '',
    ];
    return '$productId:${options.join('|')}';
  }

  // Find existing cart item with the same configuration
  Future<Either<String, CartEntity?>> _findExistingCartItem(
    String productId, {
    String? selectedVariant,
    String? selectedColor,
    String? selectedRam,
    String? selectedStorage,
  }) async {
    final cartItems = await _repository.getCartItems();

    return cartItems.fold((error) => Left(error), (items) {
      final targetKey = _generateCartItemKey(
        productId,
        selectedVariant: selectedVariant,
        selectedColor: selectedColor,
        selectedRam: selectedRam,
        selectedStorage: selectedStorage,
      );

      for (final item in items) {
        final itemKey = _generateCartItemKey(
          item.productId,
          selectedVariant: item.selectedVariant,
          selectedColor: item.selectedColor,
          selectedRam: item.selectedRam,
          selectedStorage: item.selectedStorage,
        );

        if (itemKey == targetKey) {
          return Right(item);
        }
      }
      return const Right(null);
    });
  }

  // Add a product to cart
  Future<Either<String, CartEntity>> addToCart(
    ProductEntity product, {
    ProductVariantEntity? selectedVariant,
    String? selectedColor,
    String? selectedRam,
    String? selectedStorage,
    int quantity = 1,
  }) async {
    // Check if product with same configuration already exists in cart
    final existingItem = await _findExistingCartItem(
      product.id,
      selectedVariant: selectedVariant?.name,
      selectedColor: selectedColor,
      selectedRam: selectedRam,
      selectedStorage: selectedStorage,
    );

    return existingItem.fold((error) => Left(error), (existing) async {
      if (existing != null) {
        // Update existing item quantity
        final updatedItem = CartEntity(
          id: existing.id,
          productId: existing.productId,
          productName: existing.productName,
          brand: existing.brand,
          category: existing.category,
          price: existing.price,
          image: existing.image,
          rating: existing.rating,
          reviews: existing.reviews,
          description: existing.description,
          inStock: existing.inStock,
          quantity: existing.quantity + quantity,
          selectedVariant: existing.selectedVariant,
          selectedColor: existing.selectedColor,
          selectedRam: existing.selectedRam,
          selectedStorage: existing.selectedStorage,
          addedAt: existing.addedAt,
        );
        return _repository.updateCartItem(updatedItem);
      } else {
        // Add new item to cart
        final cartItem = CartEntity(
          id: '',
          productId: product.id,
          productName: product.name,
          brand: product.brand,
          category: product.category,
          price: selectedVariant?.price ?? product.price,
          image: product.image,
          rating: product.rating,
          reviews: product.reviewsCount,
          description: product.description,
          inStock: product.inStock,
          quantity: quantity,
          selectedVariant: selectedVariant?.name,
          selectedColor: selectedColor,
          selectedRam: selectedRam,
          selectedStorage: selectedStorage,
          addedAt: DateTime.now(),
        );
        return _repository.addToCart(cartItem);
      }
    });
  }

  // Update cart item quantity by cart item ID (not product ID)
  Future<Either<String, CartEntity>> updateCartItemQuantity(
    String cartItemId,
    int quantity,
  ) async {
    final existingItem = await _repository.getCartItemById(cartItemId);

    return existingItem.fold((error) => Left(error), (existing) async {
      if (existing == null) {
        return Left('Cart item not found');
      }

      if (quantity <= 0) {
        // Remove item if quantity is 0 or negative
        final removeResult = await _repository.removeCartItemById(cartItemId);
        return removeResult.fold(
          (error) => Left(error),
          (_) => Left('Item removed from cart'),
        );
      }

      final updatedItem = CartEntity(
        id: existing.id,
        productId: existing.productId,
        productName: existing.productName,
        brand: existing.brand,
        category: existing.category,
        price: existing.price,
        image: existing.image,
        rating: existing.rating,
        reviews: existing.reviews,
        description: existing.description,
        inStock: existing.inStock,
        quantity: quantity,
        selectedVariant: existing.selectedVariant,
        selectedColor: existing.selectedColor,
        selectedRam: existing.selectedRam,
        selectedStorage: existing.selectedStorage,
        addedAt: existing.addedAt,
      );
      return _repository.updateCartItem(updatedItem);
    });
  }

  // Remove a specific cart item by its ID
  Future<Either<String, void>> removeCartItem(String cartItemId) async {
    return _repository.removeCartItemById(cartItemId);
  }

  // Remove a product from cart (legacy method - removes all variants of the product)
  Future<Either<String, void>> removeFromCart(String productId) {
    return _repository.removeFromCart(productId);
  }

  // Clear all cart items
  Future<Either<String, void>> clearCart() {
    return _repository.clearCart();
  }

  // Get cart item by product ID (legacy method - returns first match)
  Future<Either<String, CartEntity?>> getCartItemByProductId(String productId) {
    return _repository.getCartItemByProductId(productId);
  }

  // Calculate cart totals
  Future<Either<String, Map<String, dynamic>>> getCartTotals() async {
    final cartItems = await _repository.getCartItems();

    return cartItems.fold((error) => Left(error), (items) {
      double subtotal = 0;
      int totalItems = 0;

      for (final item in items) {
        subtotal += item.price * item.quantity;
        totalItems += item.quantity;
      }

      final tax = subtotal * 0.085; // 8.5% tax
      final total = subtotal + tax;

      return Right({
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'totalItems': totalItems,
      });
    });
  }
}
