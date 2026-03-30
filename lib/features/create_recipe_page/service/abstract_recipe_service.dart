import 'package:fit_eat/features/ingredient/model/ingredient_request.dart';
import '../model/recipe_model.dart';

abstract class IRecipeService {
  Future<void> createRecipe({required RecipeModel model});
  Future<void> suggestIngredient({required IngredientRequest model});
}

abstract class IRecipeDraftService {
  Future<void> saveRecipeDraft(String userId, RecipeModel draft);
  Future<void> deleteRecipeDraft(String userId);
  Future<RecipeModel?> getRecipeDraft(String userId);
}
