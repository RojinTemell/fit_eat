/// Master ingredient — `ingredients` tablosundaki bir satırı temsil eder.
///
/// MVP scope kararı: nutrition (calories/protein/fat/carbs) ve birim
/// dönüşüm (gramsPerPiece) field'ları taşınmıyor. Calorie auto-compute
/// V2 işidir; o zaman `Ingredient` ve `recipe_ingredients` ayrı bir
/// "nutrition profile" referansı üzerinden zenginleştirilir.
class Ingredient {
  final String? id;
  final String name;
  final String emoji;
  final String defaultUnit;

  const Ingredient({
    this.id,
    required this.name,
    this.emoji = '🍽️',
    this.defaultUnit = 'gram',
  });

  /// Reads a row from the Supabase `ingredients` table (snake_case keys).
  factory Ingredient.fromJson(Map<String, dynamic> data) {
    return Ingredient(
      id: data['id'] as String?,
      name: data['name'] as String? ?? '',
      emoji: data['emoji'] as String? ?? '🍽️',
      defaultUnit: data['default_unit'] as String? ?? 'gram',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'emoji': emoji,
        'default_unit': defaultUnit,
      };
}
