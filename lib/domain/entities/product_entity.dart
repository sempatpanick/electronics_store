import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';

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

  ProductModel toModel() => ProductModel(
    id: id,
    name: name,
    brand: brand,
    category: category,
    price: price,
    originalPrice: originalPrice,
    image: image,
    images: images,
    rating: rating,
    reviewsCount: reviewsCount,
    description: description,
    specifications: specifications,
    variants: variants?.map((v) => v.toModel()).toList(),
    colors: colors,
    ramOptions: ramOptions,
    storageOptions: storageOptions,
    inStock: inStock,
    stockCount: stockCount,
    reviewsList: reviewsList.map((r) => r.toModel()).toList(),
  );

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

  ProductVariantModel toModel() =>
      ProductVariantModel(name: name, price: price, available: available);

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

  ProductReviewModel toModel() => ProductReviewModel(
    id: id,
    user: user,
    rating: rating,
    date: date,
    title: title,
    comment: comment,
    verified: verified,
  );

  @override
  List<Object?> get props => [id, user, rating, date, title, comment, verified];
}
