import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/enums.dart';
import '../controllers/product_detail_cubit.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_options.dart';
import '../widgets/product_description.dart';
import '../widgets/product_reviews.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null ||
          current.isAddedToCart ||
          (previous.product != current.product && current.product != null),
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: kErrorColor,
            ),
          );
          context.read<ProductDetailCubit>().clearError();
        }

        if (state.isAddedToCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added to cart successfully!'),
              backgroundColor: kSecondaryColor,
            ),
          );
          // Reset the added to cart state
          context.read<ProductDetailCubit>().resetAddedToCart();
        }
      },
      builder: (context, state) {
        if (state.status == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == RequestState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading product',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Something went wrong',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        if (state.product == null) {
          return const Center(child: Text('Product not found'));
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
          child: ProductImageGallery(
            images: state.product!.images,
          ),
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
    return ProductReviews(
      reviews: state.product!.reviewsList,
    );
  }
}
