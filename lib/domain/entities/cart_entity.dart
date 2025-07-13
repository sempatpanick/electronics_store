import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String brand;
  final String category;
  final double price;
  final String? image;
  final double rating;
  final int reviews;
  final String description;
  final bool inStock;
  final int quantity;
  final String? selectedVariant;
  final String? selectedColor;
  final String? selectedRam;
  final String? selectedStorage;
  final DateTime addedAt;

  const CartEntity({
    required this.id,
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

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    brand,
    category,
    price,
    image,
    rating,
    reviews,
    description,
    inStock,
    quantity,
    selectedVariant,
    selectedColor,
    selectedRam,
    selectedStorage,
    addedAt,
  ];
}
