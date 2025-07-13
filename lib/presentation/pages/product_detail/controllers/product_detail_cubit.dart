import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

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

  // Track failed product loads to prevent infinite loops
  final Set<String> _failedProductIds = {};

  ProductDetailCubit() : super(ProductDetailState());

  void initialize(String productId) {
    // Only initialize if the productId has actually changed and is not empty
    if (state.productId != productId && productId.isNotEmpty) {
      // Clear failed products when starting a new product load
      _failedProductIds.clear();
      emit(state.copyWith(productId: productId));
      loadProduct(productId);
    } else if (productId.isEmpty) {
      // Handle empty product ID
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Invalid product ID',
          clearProduct: true,
        ),
      );
    }
  }

  Future<void> loadProduct(String productId) async {
    // Prevent loading if already in progress
    if (state.status == RequestState.loading) {
      return;
    }

    // Prevent loading if we've already failed to load this product
    if (_failedProductIds.contains(productId)) {
      return;
    }

    emit(state.copyWith(status: RequestState.loading));

    try {
      final productResult = await _productUseCase.getProductById(productId);
      productResult.fold(
        (error) {
          _failedProductIds.add(productId); // Mark as failed
          emit(state.copyWith(status: RequestState.error, errorMessage: error));
        },
        (product) async {
          if (product != null) {
            emit(
              state.copyWith(
                product: product,
                status: RequestState.loaded,
                selectedVariant: (product.variants?.isNotEmpty ?? false)
                    ? product.variants!.first
                    : null,
                clearSelectedVariant: !(product.variants?.isNotEmpty ?? false),
                selectedColor: (product.colors?.isNotEmpty ?? false)
                    ? product.colors!.first
                    : null,
                clearSelectedColor: !(product.colors?.isNotEmpty ?? false),
                selectedRam: (product.ramOptions?.isNotEmpty ?? false)
                    ? product.ramOptions!.first
                    : null,
                clearSelectedRam: !(product.ramOptions?.isNotEmpty ?? false),
                selectedStorage: (product.storageOptions?.isNotEmpty ?? false)
                    ? product.storageOptions!.first
                    : null,
                clearSelectedStorage:
                    !(product.storageOptions?.isNotEmpty ?? false),
              ),
            );
            // Check if product is in favorites only if product exists
            await _checkFavoriteStatus(productId);
          } else {
            _failedProductIds.add(productId); // Mark as failed
            emit(
              state.copyWith(
                status: RequestState.error,
                errorMessage: 'Product not found',
                clearProduct: true,
                isFavorite: false,
              ),
            );
          }
        },
      );
    } catch (e) {
      _failedProductIds.add(productId); // Mark as failed
      emit(
        state.copyWith(
          status: RequestState.error,
          errorMessage: 'Failed to load product: $e',
          clearProduct: true,
          isFavorite: false,
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
    try {
      // Add a timeout to prevent freezing
      final result = await _favoritesUseCase
          .isFavorite(productId)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              return const Right(false);
            },
          );

      result.fold(
        (error) {
          print('Error checking favorite status: $error');
          // Don't emit state change on error, just log it
        },
        (isFavorite) {
          // Only emit if the state is still valid (not in error state)
          if (state.status != RequestState.error) {
            emit(state.copyWith(isFavorite: isFavorite));
          } else {}
        },
      );
    } catch (e) {
      // Don't emit state change on exception, just log it
    }
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
            emit(state.copyWith(isAddedToCart: true, clearErrorMessage: true)),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add to cart: $e'));
    }
  }

  void resetAddedToCart() {
    emit(state.copyWith(isAddedToCart: false));
  }

  void clearError() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  void resetFailedProducts() {
    _failedProductIds.clear();
  }

  void updateFavoriteStatus(bool isFavorite) {
    emit(state.copyWith(isFavorite: isFavorite));
  }

  bool _validateSelections() {
    final product = state.product;
    if (product == null) return false;

    // For now, allow adding to cart without requiring all options
    // The user can select options if they want, but it's not mandatory
    return true;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
