import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../data/di/injection.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/usecases/favorites_use_case.dart';
import '../../../../domain/usecases/product_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FavoritesUseCase _favoritesUseCase = getIt<FavoritesUseCase>();
  final ProductUseCase _productUseCase = getIt<ProductUseCase>();

  ProductsCubit() : super(ProductsState()) {
    // Initialize products when cubit is created
    _loadProducts();
    _loadFavorites();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _filterProducts();
  }

  void selectCategory(String category) {
    final selectedCategories = List<String>.from(state.selectedCategories);
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    emit(state.copyWith(selectedCategories: selectedCategories));
    _filterProducts();
  }

  void clearAllFilters() {
    emit(state.copyWith(selectedCategories: [], searchQuery: ''));
    _filterProducts();
  }

  Future<void> toggleFavorite(String productId) async {
    // Get product data from ProductUseCase
    final productResult = await _productUseCase.getProductById(productId);
    productResult.fold(
      (error) => print('Error getting product: $error'),
      (product) async {
        if (product != null) {
          final result = await _favoritesUseCase.toggleFavorite(product);
          result.fold((error) => print('Error toggling favorite: $error'),
              (isFavorite) {
            final favorites = List<String>.from(state.favorites);
            if (isFavorite) {
              if (!favorites.contains(productId)) {
                favorites.add(productId);
              }
            } else {
              favorites.remove(productId);
            }
            emit(state.copyWith(favorites: favorites));
          });
        }
      },
    );
  }

  void syncFavorites(List<String> favorites) {
    emit(state.copyWith(favorites: favorites));
  }

  Future<void> _loadFavorites() async {
    final result = await _favoritesUseCase.getFavorites();
    result.fold((error) => print('Error loading favorites: $error'),
        (favorites) {
      final favoriteIds = favorites.map((f) => f.productId).toList();
      emit(state.copyWith(favorites: favoriteIds));
    });
  }

  Future<void> _loadProducts() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _productUseCase.getProducts();
      result.fold(
        (error) => emit(state.copyWith(
          status: RequestState.error,
          errorMessage: error,
        )),
        (products) => emit(state.copyWith(
          products: products,
          status: RequestState.loaded,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: RequestState.error,
        errorMessage: 'Failed to load products: $e',
      ));
    }
  }

  Future<void> _filterProducts() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _productUseCase.getFilteredProducts(
        category: state.selectedCategories.isNotEmpty
            ? state.selectedCategories.first
            : null,
        searchQuery: state.searchQuery,
      );

      result.fold(
        (error) => emit(state.copyWith(
          status: RequestState.error,
          errorMessage: error,
        )),
        (filteredProducts) => emit(state.copyWith(
          products: filteredProducts,
          status: RequestState.loaded,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: RequestState.error,
        errorMessage: 'Failed to filter products: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
