import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../pantry/domain/entities/pantry_item.dart';
import '../../domain/entities/recipe.dart';
import '../models/recipe_dto.dart';
import '../../domain/usecases/generate_recipe_usecase.dart';

@module
abstract class GeminiModule {
  @lazySingleton
  GenerativeModel get model => GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      );
}

@LazySingleton(as: RecipeService)
class GeminiRecipeService implements RecipeService {
  final GenerativeModel model;

  GeminiRecipeService(this.model);

  @override
  Future<Either<Failure, List<Recipe>>> generateRecipesFromInventory(List<PantryItem> inventory) async {
    try {
      final highPriority = inventory.where((i) => i.daysUntilExpiry <= 3).map((i) => i.name).join(', ');
      final generalStock = inventory.where((i) => i.daysUntilExpiry > 3).map((i) => i.name).join(', ');

      final prompt = '''
        You are a waste-reduction chef. 
        Generate 3 recipes in valid JSON format.
        PRIORITIZE using these expiring items: $highPriority.
        USE these general items if needed: $generalStock.
        Assume basic staples (salt, oil, water) are available.
        
        Return ONLY a JSON array of objects with these keys: 
        "title", "ingredients" (list of strings), "instructions" (list of strings), "prepTimeMinutes".
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      if (response.text == null) return const Left(LLMFailure('Empty response from Gemini'));

      final List<dynamic> decoded = jsonDecode(response.text!);
      final recipes = decoded.map((json) => RecipeDTO.fromJson(json)).toList();
      
      return Right(recipes);
    } catch (e) {
      return Left(LLMFailure(e.toString()));
    }
  }
}
