part of 'product_detail_cubit.dart';

class ProductDetailState {
  final RequestState status;
  final String? errorMessage;
  final String? productId;
  final ProductEntity? product;
  final ProductVariantEntity? selectedVariant;
  final String? selectedColor;
  final String? selectedRam;
  final String? selectedStorage;
  final int quantity;
  final bool isFavorite;
  final bool isAddedToCart;

  ProductDetailState({
    this.status = RequestState.none,
    this.errorMessage,
    this.productId,
    this.product,
    this.selectedVariant,
    this.selectedColor,
    this.selectedRam,
    this.selectedStorage,
    this.quantity = 1,
    this.isFavorite = false,
    this.isAddedToCart = false,
  });

  ProductDetailState copyWith({
    RequestState? status,
    String? errorMessage,
    String? productId,
    ProductEntity? product,
    ProductVariantEntity? selectedVariant,
    String? selectedColor,
    String? selectedRam,
    String? selectedStorage,
    int? quantity,
    bool? isFavorite,
    bool? isAddedToCart,
    bool? clearErrorMessage,
    bool? clearProduct,
    bool? clearSelectedVariant,
    bool? clearSelectedColor,
    bool? clearSelectedRam,
    bool? clearSelectedStorage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      errorMessage: (clearErrorMessage ?? false)
          ? null
          : errorMessage ?? this.errorMessage,
      productId: productId ?? this.productId,
      product: (clearProduct ?? false) ? null : product ?? this.product,
      selectedVariant: (clearSelectedVariant ?? false)
          ? null
          : selectedVariant ?? this.selectedVariant,
      selectedColor: (clearSelectedColor ?? false)
          ? null
          : selectedColor ?? this.selectedColor,
      selectedRam: (clearSelectedRam ?? false)
          ? null
          : selectedRam ?? this.selectedRam,
      selectedStorage: (clearSelectedStorage ?? false)
          ? null
          : selectedStorage ?? this.selectedStorage,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
    );
  }
}
