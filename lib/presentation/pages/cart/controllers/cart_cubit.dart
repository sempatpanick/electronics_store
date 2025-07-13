import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../data/di/injection.dart';
import '../../../../domain/entities/cart_entity.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/usecases/cart_use_case.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartUseCase _cartUseCase = getIt<CartUseCase>();

  CartCubit() : super(CartState()) {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _cartUseCase.getCartItems();
      result.fold(
        (error) => emit(
          state.copyWith(status: RequestState.error, errorMessage: error),
        ),
        (cartItems) {
          emit(
            state.copyWith(cartItems: cartItems, status: RequestState.loaded),
          );
          _calculateTotals();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to load cart items: $e',
        ),
      );
    }
  }

  Future<void> addToCart(
    ProductEntity product, {
    ProductVariantEntity? selectedVariant,
    String? selectedColor,
    String? selectedRam,
    String? selectedStorage,
    int quantity = 1,
  }) async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _cartUseCase.addToCart(
        product,
        selectedVariant: selectedVariant,
        selectedColor: selectedColor,
        selectedRam: selectedRam,
        selectedStorage: selectedStorage,
        quantity: quantity,
      );

      result.fold(
        (error) => emit(
          state.copyWith(status: RequestState.error, errorMessage: error),
        ),
        (cartEntity) async {
          // Reload cart items to get updated list
          await _loadCartItems();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to add to cart: $e',
        ),
      );
    }
  }

  Future<void> removeFromCart(String productId) async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _cartUseCase.removeFromCart(productId);
      result.fold(
        (error) => emit(
          state.copyWith(status: RequestState.error, errorMessage: error),
        ),
        (_) async {
          // Reload cart items to get updated list
          await _loadCartItems();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to remove from cart: $e',
        ),
      );
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _cartUseCase.updateCartItemQuantity(
        productId,
        quantity,
      );
      result.fold(
        (error) => emit(
          state.copyWith(status: RequestState.error, errorMessage: error),
        ),
        (cartEntity) async {
          // Reload cart items to get updated list
          await _loadCartItems();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to update quantity: $e',
        ),
      );
    }
  }

  Future<void> clearCart() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _cartUseCase.clearCart();
      result.fold(
        (error) => emit(
          state.copyWith(status: RequestState.error, errorMessage: error),
        ),
        (_) {
          emit(state.copyWith(cartItems: [], status: RequestState.loaded));
          _calculateTotals();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to clear cart: $e',
        ),
      );
    }
  }

  void _calculateTotals() {
    double subtotal = 0;
    int totalItems = 0;

    for (final item in state.cartItems) {
      subtotal += item.price * item.quantity;
      totalItems += item.quantity;
    }

    // Calculate tax (assuming 8.5% tax rate)
    final tax = subtotal * 0.085;
    final total = subtotal + tax;

    emit(
      state.copyWith(
        subtotal: subtotal,
        tax: tax,
        total: total,
        totalItems: totalItems,
      ),
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
