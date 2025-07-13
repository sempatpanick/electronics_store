import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../common/navigation_service.dart';
import '../../../../domain/entities/order_entity.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersState()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      // Simulate loading orders from API/database
      await Future.delayed(const Duration(seconds: 1));

      // Sample orders data - in a real app, this would come from a repository
      final orders = [
        OrderEntity(
          id: 'ORD-001',
          date: '2024-01-15',
          status: 'Delivered',
          total: 1299.99,
          items: 2,
          products: ['MacBook Pro 14"', 'AirPods Pro'],
        ),
        OrderEntity(
          id: 'ORD-002',
          date: '2024-01-10',
          status: 'Shipped',
          total: 349.99,
          items: 1,
          products: ['Sony WH-1000XM5'],
        ),
        OrderEntity(
          id: 'ORD-003',
          date: '2024-01-05',
          status: 'Processing',
          total: 899.99,
          items: 1,
          products: ['Samsung Galaxy S24'],
        ),
      ];

      emit(state.copyWith(
        orders: orders,
        status: RequestState.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RequestState.error,
        errorMessage: 'Failed to load orders: $e',
      ));
    }
  }

  void viewOrderDetails(String orderId) {
    // Navigate to order details page
    // For now, just show a snackbar
    print('Viewing order details for: $orderId');
  }

  void navigateToProducts(BuildContext context) {
    NavigationService.goToProducts(context);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
