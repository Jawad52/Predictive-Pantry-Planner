import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../pantry/domain/entities/pantry_item.dart';
import '../entities/recipe.dart';

abstract class RecipeService {
  Future<Either<Failure, List<Recipe>>> generateRecipesFromInventory(List<PantryItem> inventory);
}

class GenerateRecipeUseCase extends UseCase<List<Recipe>, List<PantryItem>> {
  final RecipeService recipeService;

  GenerateRecipeUseCase(this.recipeService);

  @override
  Future<Either<Failure, List<Recipe>>> call(List<PantryItem> inventory) async {
    // 1. Sort inventory by waste priority (expiring soonest)
    final sortedInventory = List<PantryItem>.from(inventory)
      ..sort((a, b) => b.wastePriority.compareTo(a.wastePriority));

    // 2. Extract high-priority items (e.g., expiring within 3 days)
    final highPriorityItems = sortedInventory
        .where((item) => item.daysUntilExpiry <= 3)
        .toList();

    // 3. Delegate to Gemini Nano / LLM Service
    return await recipeService.generateRecipesFromInventory(sortedInventory);
  }
}
