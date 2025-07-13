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
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedRam: selectedRam ?? this.selectedRam,
      selectedStorage: selectedStorage ?? this.selectedStorage,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
    );
  }
}
