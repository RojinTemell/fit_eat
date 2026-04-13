class Ingredient {
  final String? id;
  final String name;
  final String emoji;
  final bool approved;
  final String defaultUnit;
  // Nutritional values — all per 100 grams
  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;
  // Unit conversion: how many grams is one piece
  // e.g. egg → 50g, garlic clove → 5g, bread slice → 30g
  final double? gramsPerPiece;

  const Ingredient({
    this.id,
    required this.name,
    required this.emoji,
    this.approved = true,
    this.defaultUnit = 'gram',
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    this.gramsPerPiece,
  });

  /// Reads a row from the Supabase `ingredients` table (snake_case keys).
  factory Ingredient.fromJson(Map<String, dynamic> data) {
    return Ingredient(
      id: data['id'] as String?,
      name: data['name'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '🍽️',
      approved: data['approved'] as bool? ?? true,
      defaultUnit: data['default_unit'] as String? ?? 'gram',
      caloriesPer100g:
          (data['calories_per_100g'] as num?)?.toDouble() ?? 0,
      proteinPer100g:
          (data['protein_per_100g'] as num?)?.toDouble() ?? 0,
      fatPer100g: (data['fat_per_100g'] as num?)?.toDouble() ?? 0,
      carbsPer100g: (data['carbs_per_100g'] as num?)?.toDouble() ?? 0,
      gramsPerPiece: (data['grams_per_piece'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'emoji': emoji,
        'approved': approved,
        'default_unit': defaultUnit,
        'calories_per_100g': caloriesPer100g,
        'protein_per_100g': proteinPer100g,
        'fat_per_100g': fatPer100g,
        'carbs_per_100g': carbsPer100g,
        if (gramsPerPiece != null) 'grams_per_piece': gramsPerPiece,
      };
}
