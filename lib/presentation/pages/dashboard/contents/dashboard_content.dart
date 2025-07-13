import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/enums.dart';
import '../../../widgets/text_input_widget.dart';
import '../controllers/dashboard_cubit.dart';
import '../../../widgets/product_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchAndFilters(context, state),
                const SizedBox(height: 10),
                _buildProductsWrap(context, state),
              ],
            );
          },
        );
  }

  Widget _buildSearchAndFilters(BuildContext context, DashboardState state) {
    return Column(
      children: [
        TextInputWidget(
          label: 'Search products',
          hint: 'Search by name or brand...',
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) =>
              context.read<DashboardCubit>().updateSearchQuery(value),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  final isSelected = category == state.selectedCategory;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<DashboardCubit>().selectCategory(
                                category,
                              );
                        }
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: kPrimaryColor.withValues(alpha: .2),
                      labelStyle: TextStyle(
                        color: isSelected ? kPrimaryColor : kTextPrimaryColor,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color:
                            isSelected ? kPrimaryColor : Colors.grey.shade300,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductsWrap(BuildContext context, DashboardState state) {
    if (state.status == RequestState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;

    final isSmallScreen = screenWidth < 600;
    final isVerySmallScreen = screenWidth < 400;
    final spacing = isVerySmallScreen
        ? 0
        : isSmallScreen
            ? 2
            : 16;
    final runSpacing = isVerySmallScreen
        ? 0
        : isSmallScreen
            ? 2
            : 16;

    // Calculate how many products can fit in one row
    const productWidth = 180.0;
    final availableWidth = screenWidth - 48.0; // Account for padding
    final productsPerRow = (availableWidth / (productWidth + spacing)).floor();

    // Determine alignment based on whether products can fill the width
    final wrapAlignment = state.products.length >= productsPerRow
        ? WrapAlignment.center
        : WrapAlignment.start;

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: wrapAlignment,
        spacing: spacing.toDouble(),
        runSpacing: runSpacing.toDouble(),
        children: state.products.map((product) {
          return SizedBox(
            width: productWidth,
            height: 240,
            child: ProductCard(
              product: product,
              isFavorite: state.favorites.contains(product.id),
              onFavoriteToggle: () async {
                await context.read<DashboardCubit>().toggleFavorite(product.id);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
