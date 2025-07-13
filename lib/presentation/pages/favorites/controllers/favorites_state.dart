part of 'favorites_cubit.dart';

class FavoritesState {
  final RequestState status;
  final String? errorMessage;
  final List<ProductEntity> favoriteProducts;

  FavoritesState({
    this.status = RequestState.none,
    this.errorMessage,
    this.favoriteProducts = const [],
  });

  FavoritesState copyWith({
    RequestState? status,
    String? errorMessage,
    List<ProductEntity>? favoriteProducts,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }
}
