import '../../domain/entities/pantry_item.dart';

class PantryItemDTO extends PantryItem {
  const PantryItemDTO({
    required super.id,
    required super.name,
    required super.expiryDate,
    required super.quantity,
    super.unit,
    super.category,
  });

  factory PantryItemDTO.fromMap(Map<String, dynamic> map) {
    return PantryItemDTO(
      id: map['id'],
      name: map['name'],
      expiryDate: DateTime.fromMillisecondsSinceEpoch(map['expiry_date']),
      quantity: map['quantity'],
      unit: map['unit'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expiry_date': expiryDate.millisecondsSinceEpoch,
      'quantity': quantity,
      'unit': unit,
      'category': category,
    };
  }
}
