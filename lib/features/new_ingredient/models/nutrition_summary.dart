class NutritionSummary {
  final double caloriesPerServing;
  final double proteinPerServing;
  final double fatPerServing;
  final double carbsPerServing;
 
  const NutritionSummary({
    required this.caloriesPerServing,
    required this.proteinPerServing,
    required this.fatPerServing,
    required this.carbsPerServing,
  });
 
  /// Firestore'a kaydedilecek map
  Map<String, dynamic> toMap() => {
    'caloriesPerServing': caloriesPerServing.round(),
    'proteinPerServing': proteinPerServing.round(),
    'fatPerServing': fatPerServing.round(),
    'carbsPerServing': carbsPerServing.round(),
  };
}