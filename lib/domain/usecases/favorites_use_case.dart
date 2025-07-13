import 'package:dartz/dartz.dart';
import '../entities/favorite_entity.dart';
import '../entities/product_entity.dart';
import '../repositories/app_repository.dart';

class FavoritesUseCase {
  final AppRepository _repository;

  FavoritesUseCase(this._repository);

  // Get all favorites
  Future<Either<String, List<FavoriteEntity>>> getFavorites() {
    return _repository.getFavorites();
  }

  // Add a product to favorites
  Future<Either<String, FavoriteEntity>> addFavorite(ProductEntity product) {
    final favorite = FavoriteEntity(
      id: '', // Will be set by the database
      productId: product.id,
      productName: product.name,
      brand: product.brand,
      category: product.category,
      price: product.price,
      image: product.image,
      rating: product.rating,
      reviews: product.reviewsCount,
      description: product.description,
      inStock: product.inStock,
      addedAt: DateTime.now(),
    );
    return _repository.addFavorite(favorite);
  }

  // Remove a product from favorites
  Future<Either<String, void>> removeFavorite(String productId) {
    return _repository.removeFavorite(productId);
  }

  // Check if a product is in favorites
  Future<Either<String, bool>> isFavorite(String productId) {
    return _repository.isFavorite(productId);
  }

  // Clear all favorites
  Future<Either<String, void>> clearFavorites() {
    return _repository.clearFavorites();
  }

  // Toggle favorite status
  Future<Either<String, bool>> toggleFavorite(ProductEntity product) async {
    final isFavResult = await _repository.isFavorite(product.id);

    return isFavResult.fold((error) => Left(error), (isFavorite) async {
      if (isFavorite) {
        final removeResult = await _repository.removeFavorite(product.id);
        return removeResult.fold(
          (error) => Left(error),
          (_) => const Right(false),
        );
      } else {
        final addResult = await addFavorite(product);
        return addResult.fold((error) => Left(error), (_) => const Right(true));
      }
    });
  }
}
