import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel extends Equatable {
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
  final List<ProductVariantModel>? variants;
  final List<String>? colors;
  final List<String>? ramOptions;
  final List<String>? storageOptions;
  final bool inStock;
  final int? stockCount;
  @JsonKey(name: 'reviews')
  final List<ProductReviewModel> reviewsList;

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    double? originalPrice,
    String? image,
    List<String>? images,
    double? rating,
    int? reviewsCount,
    String? description,
    Map<String, String>? specifications,
    List<ProductVariantModel>? variants,
    List<String>? colors,
    List<String>? ramOptions,
    List<String>? storageOptions,
    bool? inStock,
    int? stockCount,
    List<ProductReviewModel>? reviewsList,
  }) => ProductModel(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand ?? this.brand,
    category: category ?? this.category,
    price: price ?? this.price,
    originalPrice: originalPrice ?? this.originalPrice,
    image: image ?? this.image,
    images: images ?? this.images,
    rating: rating ?? this.rating,
    reviewsCount: reviewsCount ?? this.reviewsCount,
    description: description ?? this.description,
    specifications: specifications ?? this.specifications,
    variants: variants ?? this.variants,
    colors: colors ?? this.colors,
    ramOptions: ramOptions ?? this.ramOptions,
    storageOptions: storageOptions ?? this.storageOptions,
    inStock: inStock ?? this.inStock,
    stockCount: stockCount ?? this.stockCount,
    reviewsList: reviewsList ?? this.reviewsList,
  );

  ProductEntity toEntity() => ProductEntity(
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
    variants: variants?.map((v) => v.toEntity()).toList(),
    colors: colors,
    ramOptions: ramOptions,
    storageOptions: storageOptions,
    inStock: inStock,
    stockCount: stockCount,
    reviewsList: reviewsList.map((r) => r.toEntity()).toList(),
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

@JsonSerializable(explicitToJson: true)
class ProductVariantModel extends Equatable {
  final String name;
  final double price;
  final bool available;

  const ProductVariantModel({
    required this.name,
    required this.price,
    required this.available,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantModelToJson(this);

  ProductVariantModel copyWith({
    String? name,
    double? price,
    bool? available,
  }) => ProductVariantModel(
    name: name ?? this.name,
    price: price ?? this.price,
    available: available ?? this.available,
  );

  ProductVariantEntity toEntity() =>
      ProductVariantEntity(name: name, price: price, available: available);

  @override
  List<Object?> get props => [name, price, available];
}

@JsonSerializable(explicitToJson: true)
class ProductReviewModel extends Equatable {
  final String id;
  final String user;
  final int rating;
  final String date;
  final String title;
  final String comment;
  final bool verified;

  const ProductReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.date,
    required this.title,
    required this.comment,
    required this.verified,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReviewModelToJson(this);

  ProductReviewModel copyWith({
    String? id,
    String? user,
    int? rating,
    String? date,
    String? title,
    String? comment,
    bool? verified,
  }) => ProductReviewModel(
    id: id ?? this.id,
    user: user ?? this.user,
    rating: rating ?? this.rating,
    date: date ?? this.date,
    title: title ?? this.title,
    comment: comment ?? this.comment,
    verified: verified ?? this.verified,
  );

  ProductReviewEntity toEntity() => ProductReviewEntity(
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
