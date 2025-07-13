import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../data/di/injection.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/usecases/favorites_use_case.dart';
import '../../../../domain/usecases/product_use_case.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final FavoritesUseCase _favoritesUseCase = getIt<FavoritesUseCase>();
  final ProductUseCase _productUseCase = getIt<ProductUseCase>();

  DashboardCubit() : super(DashboardState()) {
    // Initialize products when cubit is created
    _loadProducts();
    _loadFavorites();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    _filterProducts();
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
    _filterProducts();
  }

  Future<void> _loadProducts() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final productsResult = await _productUseCase.getProducts();
      final categoriesResult = await _productUseCase.getCategories();

      productsResult.fold(
        (error) {
          emit(state.copyWith(
            status: RequestState.error,
            errorMessage: error,
          ));
        },
        (products) {
          categoriesResult.fold(
            (error) => emit(state.copyWith(
              status: RequestState.error,
              errorMessage: error,
            )),
            (categories) => emit(state.copyWith(
              products: products,
              categories: categories,
              status: RequestState.loaded,
            )),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: RequestState.error,
        errorMessage: 'Failed to load products: $e',
      ));
    }
  }

  void toggleNavigationExpanded() {
    emit(state.copyWith(isNavigationExpanded: !state.isNavigationExpanded));
  }

  void setSelectedNavigationIndex(int index) {
    emit(state.copyWith(selectedNavigationIndex: index));
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

  void _filterProducts() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final result = await _productUseCase.getFilteredProducts(
        category: state.selectedCategory,
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
