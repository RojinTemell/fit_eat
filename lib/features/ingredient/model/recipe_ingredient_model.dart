import '../entities/recipe_ingredient.dart';
import 'ingredient_model.dart';

//bu model recipe modele eklenicek yapı
class RecipeIngredientModel extends RecipeIngredient {
  const RecipeIngredientModel({
    required super.ingredientId,
    required super.name,
    required super.quantity,
    required super.unit,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      ingredientId: json['ingredientId'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}



extension IngredientToRecipeIngredient on IngredientModel {
  RecipeIngredient toRecipeIngredient({
    required String quantity,
    required String unit,
  }) {
    return RecipeIngredient(
      ingredientId: id,
      name: name,
      quantity: quantity,
      unit: unit,
    );
  }
}
