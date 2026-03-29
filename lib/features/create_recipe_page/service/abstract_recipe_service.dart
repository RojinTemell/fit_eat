import 'package:fit_eat/features/new_ingredient/models/ingredient.dart';

import '../model/recipe_model.dart';

abstract class IRecipeService {
  Future<void> createRecipe({required RecipeModel model});
  Future<void> suggestIngredient({required Ingredient model});
}
