import 'package:hive_ce/hive.dart';

import '../../domain/entities/cart_entity.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 0)
class CartModel {
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
  int quantity;

  @HiveField(12)
  String? selectedVariant;

  @HiveField(13)
  String? selectedColor;

  @HiveField(14)
  String? selectedRam;

  @HiveField(15)
  String? selectedStorage;

  @HiveField(16)
  DateTime addedAt;

  CartModel({
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
    required this.quantity,
    this.selectedVariant,
    this.selectedColor,
    this.selectedRam,
    this.selectedStorage,
    required this.addedAt,
  });

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
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
      quantity: entity.quantity,
      selectedVariant: entity.selectedVariant,
      selectedColor: entity.selectedColor,
      selectedRam: entity.selectedRam,
      selectedStorage: entity.selectedStorage,
      addedAt: entity.addedAt,
    );
  }

  CartEntity toEntity() {
    return CartEntity(
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
      quantity: quantity,
      selectedVariant: selectedVariant,
      selectedColor: selectedColor,
      selectedRam: selectedRam,
      selectedStorage: selectedStorage,
      addedAt: addedAt,
    );
  }
}
