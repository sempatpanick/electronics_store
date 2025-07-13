import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../data/di/injection.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/usecases/favorites_use_case.dart';
import '../../../../domain/usecases/product_use_case.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesUseCase _favoritesUseCase = getIt<FavoritesUseCase>();
  final ProductUseCase _productUseCase = getIt<ProductUseCase>();

  FavoritesCubit() : super(FavoritesState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final favoritesResult = await _favoritesUseCase.getFavorites();
      favoritesResult.fold(
        (error) => emit(state.copyWith(
          status: RequestState.error,
          errorMessage: error,
        )),
        (favorites) async {
          // Get product details for each favorite
          final favoriteProducts = <ProductEntity>[];
          for (final favorite in favorites) {
            final productResult =
                await _productUseCase.getProductById(favorite.productId);
            productResult.fold(
              (error) =>
                  print('Error loading product ${favorite.productId}: $error'),
              (product) {
                if (product != null) {
                  favoriteProducts.add(product);
                }
              },
            );
          }

          emit(state.copyWith(
            favoriteProducts: favoriteProducts,
            status: RequestState.loaded,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: RequestState.error,
        errorMessage: 'Failed to load favorites: $e',
      ));
    }
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
            final favoriteProducts =
                List<ProductEntity>.from(state.favoriteProducts);
            if (isFavorite) {
              // Add to favorites if not already there
              if (!favoriteProducts.any((p) => p.id == productId)) {
                favoriteProducts.add(product);
              }
            } else {
              // Remove from favorites
              favoriteProducts.removeWhere((p) => p.id == productId);
            }
            emit(state.copyWith(favoriteProducts: favoriteProducts));
          });
        }
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
