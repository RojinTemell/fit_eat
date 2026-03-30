import 'package:uuid/uuid.dart';

class RecipeIngredient {
  final String id; // sadece UI için, Firestore'a kaydedilmez
  final String name;
  final double amount;
  final String unit;

  // toggleIngredient sırasında Ingredient'tan bir kere kopyalanır.
  // Kayıt anında tekrar Firestore sorgusu atmaya gerek kalmaz.
  final double caloriesPer100g;
  final double? gramsPerPiece;

  RecipeIngredient({
    String? id,
    required this.name,
    required this.amount,
    required this.unit,
    this.caloriesPer100g = 0,
    this.gramsPerPiece,
  }) : id = id ?? const Uuid().v4();

  factory RecipeIngredient.fromJson(Map<String, dynamic> data) {
    return RecipeIngredient(
      // Firestore'dan okurken id yok, otomatik üretilir
      name: data['name'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      unit: data['unit'] ?? 'gram',
      caloriesPer100g: (data['caloriesPer100g'] as num?)?.toDouble() ?? 0,
      gramsPerPiece: (data['gramsPerPiece'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    // 'id' kaydedilmez
    'name': name,
    'amount': amount,
    'unit': unit,
    'caloriesPer100g': caloriesPer100g,
    if (gramsPerPiece != null) 'gramsPerPiece': gramsPerPiece,
  };

  RecipeIngredient copyWith({
    double? amount,
    String? unit,
    double? caloriesPer100g,
    double? gramsPerPiece,
  }) {
    return RecipeIngredient(
      id: id, // aynı id korunur
      name: name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      gramsPerPiece: gramsPerPiece ?? this.gramsPerPiece,
    );
  }
}
