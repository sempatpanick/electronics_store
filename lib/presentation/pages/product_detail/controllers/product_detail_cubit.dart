import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums.dart';
import '../../../../data/di/injection.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/usecases/cart_use_case.dart';
import '../../../../domain/usecases/favorites_use_case.dart';
import '../../../../domain/usecases/product_use_case.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final FavoritesUseCase _favoritesUseCase = getIt<FavoritesUseCase>();
  final ProductUseCase _productUseCase = getIt<ProductUseCase>();
  final CartUseCase _cartUseCase = getIt<CartUseCase>();

  ProductDetailCubit() : super(ProductDetailState());

  void initialize(String productId) {
    // Only initialize if the productId has actually changed
    if (state.productId != productId) {
      emit(state.copyWith(productId: productId));
      loadProduct(productId);
    }
  }

  Future<void> loadProduct(String productId) async {
    emit(state.copyWith(status: RequestState.loading));

    try {
      final productResult = await _productUseCase.getProductById(productId);
      productResult.fold(
        (error) => emit(
          state.copyWith(status: RequestState.error, errorMessage: error),
        ),
        (product) async {
          if (product != null) {
            emit(
              state.copyWith(
                product: product,
                status: RequestState.loaded,
                selectedVariant: product.variants?.isNotEmpty == true
                    ? product.variants!.first
                    : null,
                selectedColor: product.colors?.isNotEmpty == true
                    ? product.colors!.first
                    : null,
                selectedRam: product.ramOptions?.isNotEmpty == true
                    ? product.ramOptions!.first
                    : null,
                selectedStorage: product.storageOptions?.isNotEmpty == true
                    ? product.storageOptions!.first
                    : null,
              ),
            );
            // Check if product is in favorites
            await _checkFavoriteStatus(productId);
          } else {
            emit(
              state.copyWith(
                status: RequestState.error,
                errorMessage: 'Product not found',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to load product: $e',
        ),
      );
    }
  }

  void selectVariant(ProductVariantEntity variant) {
    emit(state.copyWith(selectedVariant: variant));
  }

  void selectColor(String color) {
    emit(state.copyWith(selectedColor: color));
  }

  void selectRam(String ram) {
    emit(state.copyWith(selectedRam: ram));
  }

  void selectStorage(String storage) {
    emit(state.copyWith(selectedStorage: storage));
  }

  void updateQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  Future<void> toggleFavorite() async {
    if (state.product == null) return;

    final result = await _favoritesUseCase.toggleFavorite(state.product!);
    result.fold((error) => print('Error toggling favorite: $error'), (
      isFavorite,
    ) {
      emit(state.copyWith(isFavorite: isFavorite));
    });
  }

  Future<void> _checkFavoriteStatus(String productId) async {
    final result = await _favoritesUseCase.isFavorite(productId);
    result.fold((error) => print('Error checking favorite status: $error'), (
      isFavorite,
    ) {
      emit(state.copyWith(isFavorite: isFavorite));
    });
  }

  Future<void> addToCart() async {
    if (state.product == null) return;

    // Validate selections
    if (!_validateSelections()) {
      emit(state.copyWith(errorMessage: 'Please select all required options'));
      return;
    }

    try {
      final result = await _cartUseCase.addToCart(
        state.product!,
        selectedVariant: state.selectedVariant,
        selectedColor: state.selectedColor,
        selectedRam: state.selectedRam,
        selectedStorage: state.selectedStorage,
        quantity: state.quantity,
      );

      result.fold(
        (error) => emit(state.copyWith(errorMessage: error)),
        (cartEntity) =>
            emit(state.copyWith(isAddedToCart: true, errorMessage: null)),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add to cart: $e'));
    }
  }

  void resetAddedToCart() {
    emit(state.copyWith(isAddedToCart: false));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void updateFavoriteStatus(bool isFavorite) {
    emit(state.copyWith(isFavorite: isFavorite));
  }

  bool _validateSelections() {
    final product = state.product;
    if (product == null) return false;

    // Check if variants are required and selected
    if (product.variants != null && state.selectedVariant == null) {
      return false;
    }

    // Check if colors are required and selected
    if (product.colors != null && state.selectedColor == null) {
      return false;
    }

    // Check if RAM is required and selected
    if (product.ramOptions != null && state.selectedRam == null) {
      return false;
    }

    // Check if storage is required and selected
    if (product.storageOptions != null && state.selectedStorage == null) {
      return false;
    }

    return true;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
