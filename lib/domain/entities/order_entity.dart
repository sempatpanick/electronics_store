import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String date;
  final String status;
  final double total;
  final int items;
  final List<String> products;

  const OrderEntity({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    required this.products,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        status,
        total,
        items,
        products,
      ];
}
