part of 'orders_cubit.dart';

class OrdersState {
  final RequestState status;
  final String? errorMessage;
  final List<OrderEntity> orders;

  OrdersState({
    this.status = RequestState.none,
    this.errorMessage,
    this.orders = const [],
  });

  OrdersState copyWith({
    RequestState? status,
    String? errorMessage,
    List<OrderEntity>? orders,
  }) {
    return OrdersState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      orders: orders ?? this.orders,
    );
  }
}
