import '../model/recipe_model.dart';

abstract class IRecipeService {
  Future<void> createRecipe({required RecipeModel model});
}
