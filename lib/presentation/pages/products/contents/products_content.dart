import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../common/debouncer.dart';
import '../../../../domain/entities/product_entity.dart';
import '../controllers/products_cubit.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/text_input_widget.dart';

class ProductsContent extends StatefulWidget {
  const ProductsContent({super.key});

  @override
  State<ProductsContent> createState() => _ProductsContentState();
}

class _ProductsContentState extends State<ProductsContent> {
  late TextEditingController _searchController;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        // Sync controller with state
        if (_searchController.text != state.searchQuery) {
          _searchController.text = state.searchQuery;
        }
        final categories = _getCategories();
        final screenWidth = MediaQuery.of(context).size.width;
        final isLargeScreen =
            screenWidth >= 800; // Use 1024px breakpoint for sidebar layout

        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No categories found',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        if (isLargeScreen) {
          return _buildLargeScreenLayout(context, state, categories);
        } else {
          return _buildSmallScreenLayout(context, state, categories);
        }
      },
    );
  }

  Widget _buildLargeScreenLayout(
    BuildContext context,
    ProductsState state,
    List<Map<String, dynamic>> categories,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVeryLargeScreen = screenWidth >= 1000;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Sidebar - Categories and Filters
        Container(
          width: isVeryLargeScreen ? 300 : 250,
          margin: const EdgeInsets.only(right: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, categories.length),
                const SizedBox(height: 24),
                _buildSearchFilter(context, state),
                const SizedBox(height: 24),
                _buildCategoriesList(context, state, categories),
                const SizedBox(height: 24), // Bottom padding for scroll
              ],
            ),
          ),
        ),
        // Right Side - Products
        Expanded(child: _buildProductsSection(context, state)),
      ],
    );
  }

  Widget _buildSmallScreenLayout(
    BuildContext context,
    ProductsState state,
    List<Map<String, dynamic>> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(context, categories.length),
        const SizedBox(height: 16),
        _buildSearchFilter(context, state),
        const SizedBox(height: 16),
        _buildSimpleCategoriesList(context, state, categories),
        const SizedBox(height: 24),
        _buildProductsSection(context, state),
      ],
    );
  }

  Widget _buildSimpleCategoriesList(
    BuildContext context,
    ProductsState state,
    List<Map<String, dynamic>> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: kTextPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = state.selectedCategories.contains(
                category['name'],
              );
              final color = Color(category['color'] as int);

              return Container(
                margin: const EdgeInsets.only(right: 12),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    context.read<ProductsCubit>().selectCategory(
                      category['name'],
                    );
                  },
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kPrimaryColor.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? kPrimaryColor
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconData(category['icon'] as String),
                            color: color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category['name'] as String,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? kPrimaryColor
                                    : kTextPrimaryColor,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchFilter(BuildContext context, ProductsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search & Filter',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: kTextPrimaryColor,
              ),
            ),
            if (state.selectedCategories.isNotEmpty ||
                state.searchQuery.isNotEmpty)
              TextButton.icon(
                onPressed: () =>
                    context.read<ProductsCubit>().clearAllFilters(),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: kErrorColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextInputWidget(
          label: 'Search products',
          hint: 'Search by name or brand...',
          prefixIcon: const Icon(Icons.search),
          controller: _searchController,
          onChanged: (value) {
            _debouncer.call(() {
              context.read<ProductsCubit>().updateSearchQuery(value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    ProductsState state,
    List<Map<String, dynamic>> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: kTextPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = state.selectedCategories.contains(
              category['name'],
            );
            final color = Color(category['color'] as int);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.read<ProductsCubit>().selectCategory(
                    category['name'],
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? kPrimaryColor.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconData(category['icon'] as String),
                          color: color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['name'] as String,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? kPrimaryColor
                                        : kTextPrimaryColor,
                                  ),
                            ),
                            Text(
                              '${category['productCount']} products',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: kTextSecondaryColor),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductsSection(BuildContext context, ProductsState state) {
    final filteredProducts = _getFilteredProducts(state);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Products',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: kTextPrimaryColor,
              ),
            ),
            Text(
              '${filteredProducts.length} products found',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kTextSecondaryColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (filteredProducts.isEmpty)
          Center(
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
          ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: spacing.toDouble(),
            runSpacing: runSpacing.toDouble(),
            alignment: wrapAlignment,
            children: filteredProducts.map((product) {
              return SizedBox(
                width: productWidth,
                height: 240,
                child: ProductCard(
                  product: product,
                  isFavorite: state.favorites.contains(product.id),
                  onFavoriteToggle: () async {
                    await context.read<ProductsCubit>().toggleFavorite(
                      product.id,
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<ProductEntity> _getFilteredProducts(ProductsState state) {
    return state.products;
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'phone_android':
        return Icons.phone_android;
      case 'laptop':
        return Icons.laptop;
      case 'tablet_android':
        return Icons.tablet_android;
      case 'headphones':
        return Icons.headphones;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'cable':
        return Icons.cable;
      case 'home':
        return Icons.home;
      default:
        return Icons.category_outlined;
    }
  }

  Widget _buildHeaderSection(BuildContext context, int categoryCount) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth >= 800 && screenWidth < 1000;

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
      child: isMediumScreen
          ? Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.category, color: kPrimaryColor, size: 30),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Product Categories',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore our wide range of electronics categories',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kTextSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: kSecondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$categoryCount categories available',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.category, color: kPrimaryColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Categories',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore our wide range of electronics categories',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            color: kSecondaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$categoryCount categories available',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  List<Map<String, dynamic>> _getCategories() {
    return [
      {
        'id': 'smartphones',
        'name': 'Smartphones',
        'description': 'Latest mobile phones and smartphones',
        'icon': 'phone_android',
        'productCount': 45,
        'color': 0xFF007AFF,
      },
      {
        'id': 'laptops',
        'name': 'Laptops',
        'description': 'Portable computers and notebooks',
        'icon': 'laptop',
        'productCount': 32,
        'color': 0xFF34C759,
      },
      {
        'id': 'tablets',
        'name': 'Tablets',
        'description': 'Tablets and iPads for work and entertainment',
        'icon': 'tablet_android',
        'productCount': 28,
        'color': 0xFFFF9500,
      },
      {
        'id': 'audio',
        'name': 'Audio',
        'description': 'Headphones, speakers, and audio equipment',
        'icon': 'headphones',
        'productCount': 67,
        'color': 0xFFAF52DE,
      },
      {
        'id': 'gaming',
        'name': 'Gaming',
        'description': 'Gaming consoles and accessories',
        'icon': 'sports_esports',
        'productCount': 23,
        'color': 0xFFE60012,
      },
      {
        'id': 'cameras',
        'name': 'Cameras',
        'description': 'Digital cameras and photography equipment',
        'icon': 'camera_alt',
        'productCount': 34,
        'color': 0xFF000000,
      },
      {
        'id': 'accessories',
        'name': 'Accessories',
        'description': 'Cables, chargers, and other accessories',
        'icon': 'cable',
        'productCount': 89,
        'color': 0xFF8E8E93,
      },
      {
        'id': 'smart_home',
        'name': 'Smart Home',
        'description': 'Smart home devices and automation',
        'icon': 'home',
        'productCount': 41,
        'color': 0xFF30B0C7,
      },
    ];
  }
}
