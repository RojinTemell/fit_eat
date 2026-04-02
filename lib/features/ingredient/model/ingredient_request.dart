import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientRequest {
  final String? id;
  final String name;
  final String? emoji;
  // final bool approved;
  final String defaultUnit;
  final IngredientStatus status;
  final double caloriesPer100g;
  // final double proteinPer100g;
  // final double fatPer100g;
  // final double carbsPer100g;
  // final double? gramsPerPiece;

  const IngredientRequest({
    this.id,
    required this.name,
    this.emoji,
    this.status = IngredientStatus.pending,
    // this.approved = true,
    this.defaultUnit = 'gram',
    required this.caloriesPer100g,
    // required this.proteinPer100g,
    // required this.fatPer100g,
    // required this.carbsPer100g,
    // this.gramsPerPiece,
  });

  factory IngredientRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IngredientRequest(
      id: doc.id,
      name: data['name'] ?? '',
      emoji: data['emoji'] ?? '🍽️',
      status: IngredientStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => IngredientStatus.pending,
      ),
      // approved: data['approved'] ?? true,
      defaultUnit: data['defaultUnit'] ?? 'gram',
      caloriesPer100g: (data['caloriesPer100g'] as num?)?.toDouble() ?? 0,
      // proteinPer100g: (data['proteinPer100g'] as num?)?.toDouble() ?? 0,
      // fatPer100g: (data['fatPer100g'] as num?)?.toDouble() ?? 0,
      // carbsPer100g: (data['carbsPer100g'] as num?)?.toDouble() ?? 0,
      // gramsPerPiece: (data['gramsPerPiece'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'emoji': emoji,
    // 'approved': approved,
    'defaultUnit': defaultUnit,
    'caloriesPer100g': caloriesPer100g,
    "status": status.name,
    // 'proteinPer100g': proteinPer100g,
    // 'fatPer100g': fatPer100g,
    // 'carbsPer100g': carbsPer100g,
    // if (gramsPerPiece != null) 'gramsPerPiece': gramsPerPiece,
  };
}

enum IngredientStatus { pending, approvad, rejected }
