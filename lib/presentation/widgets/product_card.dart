import 'package:flutter/material.dart';

import '../../common/colors.dart';
import '../../common/navigation_service.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = product.price;
    final rating = product.rating;
    final reviews = product.reviewsCount;
    final inStock = product.inStock;
    final screenWidth = MediaQuery.of(context).size.width;

    final isSmallScreen = screenWidth < 600;
    final isVerySmallScreen = screenWidth < 400;

    // Set minimum font sizes for small screens
    double minFont(double fallback, {double min = 12}) =>
        fallback < min ? min : fallback;

    return InkWell(
      onTap: () {
        NavigationService.goToProductDetail(context, product.id);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: kSecondaryColor.withValues(alpha: 0.1),
              ),
              child: Stack(
                children: [
                  // Image or Placeholder
                  product.image != null
                      ? Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage(
                              isSmallScreen,
                              product,
                            );
                          },
                        )
                      : _buildPlaceholderImage(isSmallScreen, product),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? kErrorColor : Colors.grey,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        onPressed: onFavoriteToggle,
                        padding: EdgeInsets.all(isSmallScreen ? 3 : 4),
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 28 : 32,
                          minHeight: isSmallScreen ? 28 : 32,
                        ),
                      ),
                    ),
                  ),
                  // Out of Stock Badge
                  if (!inStock)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: kErrorColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Out of Stock',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 12 : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen
                          ? minFont(
                              theme.textTheme.labelMedium?.fontSize ?? 14,
                              min: 13,
                            )
                          : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 3 : 4),
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen
                          ? minFont(
                              theme.textTheme.titleSmall?.fontSize ?? 14,
                              min: 14,
                            )
                          : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 5 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: isSmallScreen ? 15 : 16,
                        color: Colors.amber,
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
                      Text(
                        rating.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen
                              ? minFont(
                                  theme.textTheme.bodySmall?.fontSize ?? 13,
                                  min: 13,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
                      if (!isVerySmallScreen)
                        Flexible(
                          child: Text(
                            '(${reviews.toString()})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: kTextSecondaryColor,
                              fontSize: isSmallScreen
                                  ? minFont(
                                      theme.textTheme.bodySmall?.fontSize ?? 13,
                                      min: 13,
                                    )
                                  : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 5 : 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen
                                ? minFont(
                                    theme.textTheme.titleMedium?.fontSize ?? 15,
                                    min: 15,
                                  )
                                : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (inStock && !isVerySmallScreen)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 7 : 8,
                            vertical: isSmallScreen ? 3 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'In Stock',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen
                                  ? minFont(
                                      theme.textTheme.bodySmall?.fontSize ?? 12,
                                      min: 12,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(
    bool isSmallScreen,
    ProductEntity product,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: kSecondaryColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: isSmallScreen ? 24 : 32,
              color: kSecondaryColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            Text(
              product.name,
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
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
}
