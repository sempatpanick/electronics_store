part of 'cart_cubit.dart';

class CartState {
  final RequestState status;
  final String? errorMessage;
  final List<CartEntity> cartItems;
  final double subtotal;
  final double tax;
  final double total;
  final int totalItems;

  CartState({
    this.status = RequestState.none,
    this.errorMessage,
    this.cartItems = const [],
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.total = 0.0,
    this.totalItems = 0,
  });

  CartState copyWith({
    RequestState? status,
    String? errorMessage,
    List<CartEntity>? cartItems,
    double? subtotal,
    double? tax,
    double? total,
    int? totalItems,
  }) {
    return CartState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      cartItems: cartItems ?? this.cartItems,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}
