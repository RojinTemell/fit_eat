import 'package:fit_eat/features/ingredient/model/ingredient_request.dart';
import '../../../core/error/result.dart';
import '../model/recipe_model.dart';

abstract class IRecipeService {
  Future<Result<String>> createRecipe({required RecipeModel model});
  Future<Result<void>> suggestIngredient({required IngredientRequest model});
  Future<Result<List<RecipeModel>>> getAllRecipes();
}

abstract class IRecipeDraftService {
  Future<Result<void>> saveRecipeDraft(String userId, RecipeModel draft);
  Future<Result<void>> deleteRecipeDraft(String userId);
  Future<Result<RecipeModel?>> getRecipeDraft(String userId);
}
