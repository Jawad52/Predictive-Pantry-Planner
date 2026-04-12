import 'package:equatable/equatable.dart';

class PantryItem extends Equatable {
  final String id;
  final String name;
  final DateTime expiryDate;
  final double quantity;
  final String unit;
  final String category;

  const PantryItem({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.quantity,
    this.unit = 'pcs',
    this.category = 'General',
  });

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  // Waste Mitigation Score Helper
  double get wastePriority {
    final days = daysUntilExpiry;
    if (days <= 0) return 100.0;
    if (days > 7) return 0.0;
    return (1 - (days / 7)) * 100;
  }

  @override
  List<Object?> get props => [id, name, expiryDate, quantity, unit, category];
}
