import '../../domain/entities/recipe.dart';
import '../../../pantry/domain/entities/ingredient.dart';

class RecipeDTO extends Recipe {
  const RecipeDTO({
    required super.id,
    required super.title,
    required super.ingredients,
    required super.instructions,
    super.calories,
    required super.prepTimeMinutes,
  });

  factory RecipeDTO.fromJson(Map<String, dynamic> json) {
    return RecipeDTO(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'Unknown Recipe',
      ingredients: (json['ingredients'] as List? ?? [])
          .map((i) => Ingredient(
                id: '',
                name: i.toString(),
                expiryDate: DateTime.now(),
                quantity: 1,
              ))
          .toList(),
      instructions: List<String>.from(json['instructions'] ?? []),
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      calories: json['calories']?.toDouble(),
    );
  }
}
