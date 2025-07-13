import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final String? image;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final String description;
  final Map<String, String> specifications;
  final List<ProductVariantEntity>? variants;
  final List<String>? colors;
  final List<String>? ramOptions;
  final List<String>? storageOptions;
  final bool inStock;
  final int? stockCount;
  final List<ProductReviewEntity> reviewsList;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    this.image,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    required this.specifications,
    this.variants,
    this.colors,
    this.ramOptions,
    this.storageOptions,
    required this.inStock,
    this.stockCount,
    required this.reviewsList,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        category,
        price,
        originalPrice,
        image,
        images,
        rating,
        reviewsCount,
        description,
        specifications,
        variants,
        colors,
        ramOptions,
        storageOptions,
        inStock,
        stockCount,
        reviewsList,
      ];
}

class ProductVariantEntity extends Equatable {
  final String name;
  final double price;
  final bool available;

  const ProductVariantEntity({
    required this.name,
    required this.price,
    required this.available,
  });

  @override
  List<Object?> get props => [name, price, available];
}

class ProductReviewEntity extends Equatable {
  final String id;
  final String user;
  final int rating;
  final String date;
  final String title;
  final String comment;
  final bool verified;

  const ProductReviewEntity({
    required this.id,
    required this.user,
    required this.rating,
    required this.date,
    required this.title,
    required this.comment,
    required this.verified,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        rating,
        date,
        title,
        comment,
        verified,
      ];
}
