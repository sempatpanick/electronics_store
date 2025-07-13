import 'package:hive/hive.dart';
import '../../domain/entities/favorite_entity.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 1)
class FavoriteModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String productId;

  @HiveField(2)
  String productName;

  @HiveField(3)
  String brand;

  @HiveField(4)
  String category;

  @HiveField(5)
  double price;

  @HiveField(6)
  String? image;

  @HiveField(7)
  double rating;

  @HiveField(8)
  int reviews;

  @HiveField(9)
  String description;

  @HiveField(10)
  bool inStock;

  @HiveField(11)
  DateTime addedAt;

  FavoriteModel({
    this.id = '',
    required this.productId,
    required this.productName,
    required this.brand,
    required this.category,
    required this.price,
    this.image,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.inStock,
    required this.addedAt,
  });

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      brand: entity.brand,
      category: entity.category,
      price: entity.price,
      image: entity.image,
      rating: entity.rating,
      reviews: entity.reviews,
      description: entity.description,
      inStock: entity.inStock,
      addedAt: entity.addedAt,
    );
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      productId: productId,
      productName: productName,
      brand: brand,
      category: category,
      price: price,
      image: image,
      rating: rating,
      reviews: reviews,
      description: description,
      inStock: inStock,
      addedAt: addedAt,
    );
  }
}
