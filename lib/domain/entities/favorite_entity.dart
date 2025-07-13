import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
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
  final DateTime addedAt;

  const FavoriteEntity({
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
    addedAt,
  ];
}
