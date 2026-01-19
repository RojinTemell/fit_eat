class RecipeIngredient {
  final String ingredientId;
  final String name;
  final String quantity;
  final String unit;

  const RecipeIngredient({
    required this.ingredientId,
    required this.name,
    required this.quantity,
    required this.unit,
  });
}

extension RecipeIngredientCopy on RecipeIngredient {
  RecipeIngredient copyWith({String? quantity, String? unit}) {
    return RecipeIngredient(
      ingredientId: ingredientId,
      name: name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
