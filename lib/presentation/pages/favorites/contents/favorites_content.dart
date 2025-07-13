import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/enums.dart';
import '../../../../common/navigation_service.dart';
import '../../../widgets/product_card.dart';
import '../controllers/favorites_cubit.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
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
                  'Error loading favorites',
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
            _buildFavoritesHeader(context, state.favoriteProducts.length),
            const SizedBox(height: 24),
            if (state.favoriteProducts.isEmpty)
              _buildEmptyFavoritesState(context)
            else
              _buildFavoritesGrid(context, state),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesHeader(BuildContext context, int favoriteCount) {
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
            child: Icon(Icons.favorite, color: kPrimaryColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Favorites',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your saved products and wishlist items',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: kTextSecondaryColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: kSecondaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$favoriteCount favorite${favoriteCount != 1 ? 's' : ''}',
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
          if (favoriteCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$favoriteCount items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavoritesState(BuildContext context) {
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
                Icons.favorite_border,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No favorites yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding products to your favorites to see them here',
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

  Widget _buildFavoritesGrid(BuildContext context, FavoritesState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isVerySmallScreen = screenWidth < 400;
    final spacing = isVerySmallScreen
        ? 8.0
        : isSmallScreen
            ? 12.0
            : 16.0;
    final runSpacing = isVerySmallScreen
        ? 8.0
        : isSmallScreen
            ? 12.0
            : 16.0;

    // Calculate responsive product width
    final productWidth = isVerySmallScreen
        ? 160.0
        : isSmallScreen
            ? 170.0
            : 180.0;
    final productHeight = isVerySmallScreen
        ? 220.0
        : isSmallScreen
            ? 230.0
            : 240.0;

    // Calculate how many products can fit in one row
    final availableWidth = screenWidth - 48.0; // Account for padding
    final productsPerRow = (availableWidth / (productWidth + spacing)).floor();

    // Determine alignment based on whether products can fill the width
    final wrapAlignment = state.favoriteProducts.length >= productsPerRow
        ? WrapAlignment.center
        : WrapAlignment.start;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Favorite Products',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kTextPrimaryColor,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kSecondaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${state.favoriteProducts.length} items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: wrapAlignment,
            children: state.favoriteProducts.map((product) {
              return SizedBox(
                width: productWidth,
                height: productHeight,
                child: ProductCard(
                  product: product,
                  isFavorite: true,
                  onFavoriteToggle: () async {
                    await context
                        .read<FavoritesCubit>()
                        .toggleFavorite(product.id);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        if (state.favoriteProducts.isNotEmpty) ...[
          const SizedBox(height: 32),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: kSecondaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Click the heart icon on any product to remove it from favorites',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: kTextSecondaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
