import '../../domain/entities/product_entity.dart';

class ProductModel {
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
  final List<ProductReviewModel> reviewsList;

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      image: json['image'] as String?,
      images: List<String>.from(json['images'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int,
      description: json['description'] as String,
      specifications: Map<String, String>.from(json['specifications'] as Map),
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) =>
                  ProductVariantModel.fromJson(v as Map<String, dynamic>))
              .toList()
          : null,
      colors: json['colors'] != null
          ? List<String>.from(json['colors'] as List)
          : null,
      ramOptions: json['ramOptions'] != null
          ? List<String>.from(json['ramOptions'] as List)
          : null,
      storageOptions: json['storageOptions'] != null
          ? List<String>.from(json['storageOptions'] as List)
          : null,
      inStock: json['inStock'] as bool,
      stockCount: json['stockCount'] as int?,
      reviewsList: (json['reviews'] as List)
          .map((r) => ProductReviewModel.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'images': images,
      'rating': rating,
      'reviews_count': reviewsCount,
      'description': description,
      'specifications': specifications,
      'variants': variants?.map((v) => v.toJson()).toList(),
      'colors': colors,
      'ramOptions': ramOptions,
      'storageOptions': storageOptions,
      'inStock': inStock,
      'stockCount': stockCount,
      'reviews': reviewsList.map((r) => r.toJson()).toList(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
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
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      brand: entity.brand,
      category: entity.category,
      price: entity.price,
      originalPrice: entity.originalPrice,
      image: entity.image,
      images: entity.images,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      description: entity.description,
      specifications: entity.specifications,
      variants: entity.variants
          ?.map((v) => ProductVariantModel.fromEntity(v))
          .toList(),
      colors: entity.colors,
      ramOptions: entity.ramOptions,
      storageOptions: entity.storageOptions,
      inStock: entity.inStock,
      stockCount: entity.stockCount,
      reviewsList: entity.reviewsList
          .map((r) => ProductReviewModel.fromEntity(r))
          .toList(),
    );
  }
}

class ProductVariantModel {
  final String name;
  final double price;
  final bool available;

  ProductVariantModel({
    required this.name,
    required this.price,
    required this.available,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      available: json['available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'available': available,
    };
  }

  ProductVariantEntity toEntity() {
    return ProductVariantEntity(
      name: name,
      price: price,
      available: available,
    );
  }

  factory ProductVariantModel.fromEntity(ProductVariantEntity entity) {
    return ProductVariantModel(
      name: entity.name,
      price: entity.price,
      available: entity.available,
    );
  }
}

class ProductReviewModel {
  final String id;
  final String user;
  final int rating;
  final String date;
  final String title;
  final String comment;
  final bool verified;

  ProductReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.date,
    required this.title,
    required this.comment,
    required this.verified,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] as String,
      user: json['user'] as String,
      rating: json['rating'] as int,
      date: json['date'] as String,
      title: json['title'] as String,
      comment: json['comment'] as String,
      verified: json['verified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'rating': rating,
      'date': date,
      'title': title,
      'comment': comment,
      'verified': verified,
    };
  }

  ProductReviewEntity toEntity() {
    return ProductReviewEntity(
      id: id,
      user: user,
      rating: rating,
      date: date,
      title: title,
      comment: comment,
      verified: verified,
    );
  }

  factory ProductReviewModel.fromEntity(ProductReviewEntity entity) {
    return ProductReviewModel(
      id: entity.id,
      user: entity.user,
      rating: entity.rating,
      date: entity.date,
      title: entity.title,
      comment: entity.comment,
      verified: entity.verified,
    );
  }
}
