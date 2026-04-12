import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final DateTime expiryDate;
  final double quantity;
  final String unit;

  const Ingredient({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.quantity,
    this.unit = 'pcs',
  });

  @override
  List<Object?> get props => [id, name, expiryDate, quantity, unit];
}
