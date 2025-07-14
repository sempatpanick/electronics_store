// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  brand: json['brand'] as String,
  category: json['category'] as String,
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  image: json['image'] as String?,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  rating: (json['rating'] as num).toDouble(),
  reviewsCount: (json['reviewsCount'] as num).toInt(),
  description: json['description'] as String,
  specifications: Map<String, String>.from(json['specifications'] as Map),
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => ProductVariantModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  colors: (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  ramOptions: (json['ramOptions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  storageOptions: (json['storageOptions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  inStock: json['inStock'] as bool,
  stockCount: (json['stockCount'] as num?)?.toInt(),
  reviewsList: (json['reviews'] as List<dynamic>)
      .map((e) => ProductReviewModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'category': instance.category,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'image': instance.image,
      'images': instance.images,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'description': instance.description,
      'specifications': instance.specifications,
      'variants': instance.variants?.map((e) => e.toJson()).toList(),
      'colors': instance.colors,
      'ramOptions': instance.ramOptions,
      'storageOptions': instance.storageOptions,
      'inStock': instance.inStock,
      'stockCount': instance.stockCount,
      'reviews': instance.reviewsList.map((e) => e.toJson()).toList(),
    };

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) =>
    ProductVariantModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      available: json['available'] as bool,
    );

Map<String, dynamic> _$ProductVariantModelToJson(
  ProductVariantModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'available': instance.available,
};

ProductReviewModel _$ProductReviewModelFromJson(Map<String, dynamic> json) =>
    ProductReviewModel(
      id: json['id'] as String,
      user: json['user'] as String,
      rating: (json['rating'] as num).toInt(),
      date: json['date'] as String,
      title: json['title'] as String,
      comment: json['comment'] as String,
      verified: json['verified'] as bool,
    );

Map<String, dynamic> _$ProductReviewModelToJson(ProductReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'rating': instance.rating,
      'date': instance.date,
      'title': instance.title,
      'comment': instance.comment,
      'verified': instance.verified,
    };
