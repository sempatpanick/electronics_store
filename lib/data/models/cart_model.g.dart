// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartModelAdapter extends TypeAdapter<CartModel> {
  @override
  final int typeId = 0;

  @override
  CartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      brand: fields[3] as String,
      category: fields[4] as String,
      price: fields[5] as double,
      image: fields[6] as String?,
      rating: fields[7] as double,
      reviews: fields[8] as int,
      description: fields[9] as String,
      inStock: fields[10] as bool,
      quantity: fields[11] as int,
      selectedVariant: fields[12] as String?,
      selectedColor: fields[13] as String?,
      selectedRam: fields[14] as String?,
      selectedStorage: fields[15] as String?,
      addedAt: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.reviews)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.inStock)
      ..writeByte(11)
      ..write(obj.quantity)
      ..writeByte(12)
      ..write(obj.selectedVariant)
      ..writeByte(13)
      ..write(obj.selectedColor)
      ..writeByte(14)
      ..write(obj.selectedRam)
      ..writeByte(15)
      ..write(obj.selectedStorage)
      ..writeByte(16)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
