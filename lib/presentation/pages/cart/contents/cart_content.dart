import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/enums.dart';
import '../../../../common/navigation_service.dart';
import '../controllers/cart_cubit.dart';
import '../widgets/cart_item_card.dart';

class CartContent extends StatelessWidget {
  const CartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous.cartItems != current.cartItems,
      listener: (context, state) {
        // Cart items are now managed by CartCubit directly
      },
      buildWhen: (previous, current) =>
          previous.cartItems != current.cartItems ||
          previous.total != current.total ||
          previous.totalItems != current.totalItems ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.status == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == RequestState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Error loading cart',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Something went wrong',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCartHeader(context, state),
            const SizedBox(height: 24),
            if (state.cartItems.isEmpty)
              _buildEmptyCartState(context)
            else
              _buildCartItems(context, state),
          ],
        );
      },
    );
  }

  Widget _buildCartHeader(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withValues(alpha: 0.1),
            kSecondaryColor.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.shopping_cart, color: kPrimaryColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shopping Cart',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Review your items and proceed to checkout',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kTextSecondaryColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: kSecondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${state.totalItems} item${state.totalItems != 1 ? 's' : ''} in cart',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (state.cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '\$${state.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add some products to your cart to get started',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => NavigationService.goToProducts(context),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Browse Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, CartState state) {
    return Column(
      children: [
        // Cart Items List
        Column(
          children: state.cartItems.map((cartItem) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CartItemCard(
                cartItem: cartItem,
                onQuantityChanged: (quantity) {
                  context.read<CartCubit>().updateQuantity(
                        cartItem.productId,
                        quantity,
                      );
                },
                onRemove: () {
                  context.read<CartCubit>().removeFromCart(cartItem.productId);
                },
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Cart Summary
        _buildCartSummary(context, state),

        const SizedBox(height: 24),

        // Action Buttons
        _buildActionButtons(context, state),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Subtotal',
            '\$${state.subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow('Tax (8.5%)', '\$${state.tax.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total',
            '\$${state.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? kTextPrimaryColor : kTextSecondaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? kPrimaryColor : kTextPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, CartState state) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.read<CartCubit>().clearCart(),
            icon: const Icon(Icons.clear),
            label: const Text('Clear Cart'),
            style: OutlinedButton.styleFrom(
              foregroundColor: kErrorColor,
              side: BorderSide(color: kErrorColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement checkout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout functionality coming soon!'),
                  backgroundColor: kSecondaryColor,
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Proceed to Checkout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
