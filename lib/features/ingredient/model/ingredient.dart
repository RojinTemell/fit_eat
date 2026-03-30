import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String? id;
  final String name;
  final String emoji;
  final bool approved;
  final String defaultUnit;
  // Besin değerleri — HEPSİ 100 gram başına
  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;

  // Gram dönüşümü: kullanıcı "3 adet" dediğinde kaç gram
  // Örn: yumurta → 50g, sarımsak dişi → 5g, dilim ekmek → 30g
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

  factory Ingredient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ingredient(
      id: doc.id,
      name: data['name'] ?? '',
      emoji: data['emoji'] ?? '🍽️',
      approved: data['approved'] ?? true,
      defaultUnit: data['defaultUnit'] ?? 'gram',
      caloriesPer100g: (data['caloriesPer100g'] as num?)?.toDouble() ?? 0,
      proteinPer100g: (data['proteinPer100g'] as num?)?.toDouble() ?? 0,
      fatPer100g: (data['fatPer100g'] as num?)?.toDouble() ?? 0,
      carbsPer100g: (data['carbsPer100g'] as num?)?.toDouble() ?? 0,
      gramsPerPiece: (data['gramsPerPiece'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'emoji': emoji,
    'approved': approved,
    'defaultUnit': defaultUnit,
    'caloriesPer100g': caloriesPer100g,
    'proteinPer100g': proteinPer100g,
    'fatPer100g': fatPer100g,
    'carbsPer100g': carbsPer100g,
    if (gramsPerPiece != null) 'gramsPerPiece': gramsPerPiece,
  };
}
