import 'package:flutter/material.dart';

import '../../../../common/colors.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductOptions extends StatelessWidget {
  final ProductEntity product;
  final ProductVariantEntity? selectedVariant;
  final String? selectedColor;
  final String? selectedRam;
  final String? selectedStorage;
  final int quantity;
  final bool isFavorite;
  final Function(ProductVariantEntity) onVariantSelected;
  final Function(String) onColorSelected;
  final Function(String) onRamSelected;
  final Function(String) onStorageSelected;
  final Function(int) onQuantityChanged;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;

  const ProductOptions({
    super.key,
    required this.product,
    required this.selectedVariant,
    required this.selectedColor,
    required this.selectedRam,
    required this.selectedStorage,
    required this.quantity,
    required this.isFavorite,
    required this.onVariantSelected,
    required this.onColorSelected,
    required this.onRamSelected,
    required this.onStorageSelected,
    required this.onQuantityChanged,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final price = selectedVariant?.price ?? product.price;
    final originalPrice = product.originalPrice;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title and Brand
          Text(
            product.brand,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
          ),
          const SizedBox(height: 16),

          // Rating and Reviews
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                product.rating.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.reviewsList.length} reviews)',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: kTextSecondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Price
          Row(
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
              ),
              if (originalPrice != null && originalPrice > price) ...[
                const SizedBox(width: 12),
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kTextSecondaryColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kErrorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(((originalPrice - price) / originalPrice) * 100).round()}% OFF',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kErrorColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Variants (if available)
          if (product.variants != null) ...[
            _buildVariantSection(
              context,
              'Storage',
              product.variants!,
              selectedVariant,
              (variant) => onVariantSelected(variant),
            ),
            const SizedBox(height: 20),
          ],

          // Colors (if available)
          if (product.colors != null) ...[
            _buildOptionSection(
              context,
              'Color',
              product.colors!.map((color) => {'name': color}).toList(),
              selectedColor != null ? {'name': selectedColor} : null,
              (color) => onColorSelected(color['name']),
            ),
            const SizedBox(height: 20),
          ],

          // RAM Options (if available)
          if (product.ramOptions != null) ...[
            _buildOptionSection(
              context,
              'Memory',
              product.ramOptions!.map((ram) => {'name': ram}).toList(),
              selectedRam != null ? {'name': selectedRam} : null,
              (ram) => onRamSelected(ram['name']),
            ),
            const SizedBox(height: 20),
          ],

          // Storage Options (if available)
          if (product.storageOptions != null) ...[
            _buildOptionSection(
              context,
              'Storage',
              product.storageOptions!
                  .map((storage) => {'name': storage})
                  .toList(),
              selectedStorage != null ? {'name': selectedStorage} : null,
              (storage) => onStorageSelected(storage['name']),
            ),
            const SizedBox(height: 20),
          ],

          // Quantity Selector
          _buildQuantitySelector(context),
          const SizedBox(height: 24),

          // Stock Status
          _buildStockStatus(context),
          const SizedBox(height: 24),

          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildVariantSection(
    BuildContext context,
    String title,
    List<ProductVariantEntity> variants,
    ProductVariantEntity? selectedVariant,
    Function(ProductVariantEntity) onVariantSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextPrimaryColor,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: variants.map((variant) {
            final isSelected =
                selectedVariant != null && selectedVariant.name == variant.name;
            return InkWell(
              onTap: () => onVariantSelected(variant),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kPrimaryColor.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      variant.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                isSelected ? kPrimaryColor : kTextPrimaryColor,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${variant.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? kPrimaryColor
                                : kTextSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionSection(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> options,
    Map<String, dynamic>? selectedOption,
    Function(Map<String, dynamic>) onOptionSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextPrimaryColor,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedOption != null &&
                selectedOption['name'] == option['name'];
            return InkWell(
              onTap: () => onOptionSelected(option),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kPrimaryColor.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option['name'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? kPrimaryColor : kTextPrimaryColor,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: kTextPrimaryColor,
              ),
        ),
        const SizedBox(height: 12),
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
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onQuantityChanged(quantity + 1),
                    icon: Icon(Icons.add, color: kPrimaryColor, size: 20),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '${product.inStock ? 'In Stock' : 'Out of Stock'}${product.stockCount != null ? ' (${product.stockCount} available)' : ''}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: product.inStock ? kSecondaryColor : kErrorColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: product.inStock
            ? kSecondaryColor.withValues(alpha: 0.1)
            : kErrorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: product.inStock
              ? kSecondaryColor.withValues(alpha: 0.3)
              : kErrorColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            product.inStock ? Icons.check_circle : Icons.cancel,
            color: product.inStock ? kSecondaryColor : kErrorColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.inStock ? 'In Stock' : 'Out of Stock',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: product.inStock ? kSecondaryColor : kErrorColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (product.stockCount != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${product.stockCount} units available',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              product.inStock ? kSecondaryColor : kErrorColor,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Add to Cart Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: product.inStock ? onAddToCart : null,
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              product.inStock ? 'Add to Cart' : 'Out of Stock',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  product.inStock ? kPrimaryColor : Colors.grey.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Favorite Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onFavoriteToggle,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? kErrorColor : kPrimaryColor,
            ),
            label: Text(
              isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isFavorite ? kErrorColor : kPrimaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isFavorite ? kErrorColor : kPrimaryColor,
              ),
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
