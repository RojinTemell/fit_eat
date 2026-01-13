import '../model/ingredient_model.dart';

abstract class IngredientRepository {
  Future<List<IngredientModel>> getIngredients();
}
