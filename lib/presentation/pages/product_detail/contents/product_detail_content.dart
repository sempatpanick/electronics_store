import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/enums.dart';
import '../../../../common/navigation_service.dart';
import '../controllers/product_detail_cubit.dart';
import '../widgets/product_description.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_options.dart';
import '../widgets/product_reviews.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.isAddedToCart != current.isAddedToCart,
      listener: (context, state) {
        // Handle error messages
        if ((state.errorMessage ?? "").isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: kErrorColor,
            ),
          );
          context.read<ProductDetailCubit>().clearError();
        }
        // Handle success messages
        if (state.isAddedToCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Product added to cart successfully!'),
              backgroundColor: kSecondaryColor,
            ),
          );
          context.read<ProductDetailCubit>().resetAddedToCart();
        }
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.productId != current.productId ||
          previous.product != current.product ||
          previous.selectedVariant != current.selectedVariant ||
          previous.selectedColor != current.selectedColor ||
          previous.selectedRam != current.selectedRam ||
          previous.selectedStorage != current.selectedStorage ||
          previous.quantity != current.quantity ||
          previous.isFavorite != current.isFavorite,
      builder: (context, state) {
        if (state.status == RequestState.loading ||
            state.status == RequestState.none) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == RequestState.error && state.product == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Product not found',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  'The product you are looking for does not exist.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => NavigationService.goToProducts(context),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Browse Products'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final isLargeScreen = screenWidth >= 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Product Images and Options
            if (isLargeScreen)
              _buildLargeScreenSection1(context, state)
            else
              _buildSmallScreenSection1(context, state),

            const SizedBox(height: 32),

            // Section 2: Description and Specifications
            _buildSection2(context, state),

            const SizedBox(height: 32),

            // Section 3: Reviews
            _buildSection3(context, state),
          ],
        );
      },
    );
  }

  Widget _buildLargeScreenSection1(
    BuildContext context,
    ProductDetailState state,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Product Images
        Expanded(
          flex: 1,
          child: ProductImageGallery(images: state.product!.images),
        ),
        const SizedBox(width: 32),
        // Right side - Product Options
        Expanded(
          flex: 1,
          child: ProductOptions(
            product: state.product!,
            selectedVariant: state.selectedVariant,
            selectedColor: state.selectedColor,
            selectedRam: state.selectedRam,
            selectedStorage: state.selectedStorage,
            quantity: state.quantity,
            isFavorite: state.isFavorite,
            onVariantSelected: (variant) =>
                context.read<ProductDetailCubit>().selectVariant(variant),
            onColorSelected: (color) =>
                context.read<ProductDetailCubit>().selectColor(color),
            onRamSelected: (ram) =>
                context.read<ProductDetailCubit>().selectRam(ram),
            onStorageSelected: (storage) =>
                context.read<ProductDetailCubit>().selectStorage(storage),
            onQuantityChanged: (quantity) =>
                context.read<ProductDetailCubit>().updateQuantity(quantity),
            onFavoriteToggle: () async {
              await context.read<ProductDetailCubit>().toggleFavorite();
            },
            onAddToCart: () => context.read<ProductDetailCubit>().addToCart(),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreenSection1(
    BuildContext context,
    ProductDetailState state,
  ) {
    return Column(
      children: [
        // Product Images
        ProductImageGallery(images: state.product!.images),
        const SizedBox(height: 24),
        // Product Options
        ProductOptions(
          product: state.product!,
          selectedVariant: state.selectedVariant,
          selectedColor: state.selectedColor,
          selectedRam: state.selectedRam,
          selectedStorage: state.selectedStorage,
          quantity: state.quantity,
          isFavorite: state.isFavorite,
          onVariantSelected: (variant) =>
              context.read<ProductDetailCubit>().selectVariant(variant),
          onColorSelected: (color) =>
              context.read<ProductDetailCubit>().selectColor(color),
          onRamSelected: (ram) =>
              context.read<ProductDetailCubit>().selectRam(ram),
          onStorageSelected: (storage) =>
              context.read<ProductDetailCubit>().selectStorage(storage),
          onQuantityChanged: (quantity) =>
              context.read<ProductDetailCubit>().updateQuantity(quantity),
          onFavoriteToggle: () async {
            await context.read<ProductDetailCubit>().toggleFavorite();
          },
          onAddToCart: () => context.read<ProductDetailCubit>().addToCart(),
        ),
      ],
    );
  }

  Widget _buildSection2(BuildContext context, ProductDetailState state) {
    return ProductDescription(product: state.product!);
  }

  Widget _buildSection3(BuildContext context, ProductDetailState state) {
    return ProductReviews(reviews: state.product!.reviewsList);
  }
}
