import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../common/navigation_service.dart';
import '../../../../domain/entities/cart_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartEntity cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final quantity = cartItem.quantity;
    final price = cartItem.price;
    final totalPrice = price * quantity;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductInfo(context),
                  const SizedBox(height: 8),
                  _buildProductOptions(),
                  const SizedBox(height: 12),
                  _buildQuantityAndPrice(context, quantity, price, totalPrice),
                ],
              ),
            ),

            // Remove Button
            _buildRemoveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () =>
            NavigationService.goToProductDetail(context, cartItem.productId),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kSecondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: cartItem.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    cartItem.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  ),
                )
              : _buildPlaceholderImage(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 24,
              color: kSecondaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              cartItem.productName,
              style: TextStyle(
                fontSize: 10,
                color: kSecondaryColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.brand,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: kSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          cartItem.productName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextPrimaryColor,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProductOptions() {
    final options = <String>[];

    if (cartItem.selectedVariant != null) {
      options.add(cartItem.selectedVariant!);
    }
    if (cartItem.selectedColor != null) {
      options.add(cartItem.selectedColor!);
    }
    if (cartItem.selectedRam != null) {
      options.add(cartItem.selectedRam!);
    }
    if (cartItem.selectedStorage != null) {
      options.add(cartItem.selectedStorage!);
    }

    if (options.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: options.map((option) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            option,
            style: TextStyle(
              fontSize: 12,
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantityAndPrice(
    BuildContext context,
    int quantity,
    double price,
    double totalPrice,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Quantity Controls
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: quantity > 1
                        ? () => onQuantityChanged(quantity - 1)
                        : null,
                    icon: Icon(
                      Icons.remove,
                      color:
                          quantity > 1 ? kPrimaryColor : Colors.grey.shade400,
                      size: 18,
                    ),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onQuantityChanged(quantity + 1),
                    icon: Icon(Icons.add, color: kPrimaryColor, size: 18),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kTextSecondaryColor,
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return IconButton(
      onPressed: onRemove,
      icon: Icon(Icons.delete_outline, color: kErrorColor, size: 20),
      tooltip: 'Remove from cart',
    );
  }
}
