part of 'dashboard_cubit.dart';

class DashboardState {
  final RequestState status;
  final String? errorMessage;
  final String searchQuery;
  final String selectedCategory;
  final bool isNavigationExpanded;
  final int selectedNavigationIndex;
  final List<ProductEntity> products;
  final List<String> favorites;
  final List<String> categories;

  DashboardState({
    this.status = RequestState.none,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.isNavigationExpanded = true,
    this.selectedNavigationIndex = 0,
    this.products = const [],
    this.favorites = const [],
    this.categories = const [
      'All',
      'Smartphones',
      'Laptops',
      'Tablets',
      'Audio',
      'Gaming',
      'Cameras',
      'Accessories',
    ],
  });

  DashboardState copyWith({
    RequestState? status,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategory,
    bool? isNavigationExpanded,
    int? selectedNavigationIndex,
    List<ProductEntity>? products,
    List<String>? favorites,
    List<String>? categories,
  }) {
    return DashboardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isNavigationExpanded: isNavigationExpanded ?? this.isNavigationExpanded,
      selectedNavigationIndex:
          selectedNavigationIndex ?? this.selectedNavigationIndex,
      products: products ?? this.products,
      favorites: favorites ?? this.favorites,
      categories: categories ?? this.categories,
    );
  }
}
