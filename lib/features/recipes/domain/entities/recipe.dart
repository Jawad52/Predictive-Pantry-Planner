import 'package:equatable/equatable.dart';
import '../../../pantry/domain/entities/ingredient.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final double? calories;

  const Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    this.calories,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        ingredients,
        instructions,
        prepTimeMinutes,
        calories,
      ];
}
