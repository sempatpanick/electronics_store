part of 'products_cubit.dart';

class ProductsState {
  final RequestState status;
  final String? errorMessage;
  final String searchQuery;
  final List<String> selectedCategories;
  final List<ProductEntity> products;
  final List<String> favorites;

  ProductsState({
    this.status = RequestState.none,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategories = const [],
    this.products = const [],
    this.favorites = const [],
  });

  ProductsState copyWith({
    RequestState? status,
    String? errorMessage,
    String? searchQuery,
    List<String>? selectedCategories,
    List<ProductEntity>? products,
    List<String>? favorites,
  }) {
    return ProductsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      products: products ?? this.products,
      favorites: favorites ?? this.favorites,
    );
  }
}
