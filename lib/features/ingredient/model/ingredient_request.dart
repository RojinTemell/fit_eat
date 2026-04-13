class IngredientRequest {
  final String? id;
  final String name;
  final String? emoji;
  final String defaultUnit;
  final IngredientStatus status;
  final double caloriesPer100g;

  const IngredientRequest({
    this.id,
    required this.name,
    this.emoji,
    this.status = IngredientStatus.pending,
    this.defaultUnit = 'gram',
    required this.caloriesPer100g,
  });

  factory IngredientRequest.fromJson(Map<String, dynamic> data, {String? id}) {
    return IngredientRequest(
      id: id ?? data['id'] as String?,
      name: data['name'] as String? ?? '',
      emoji: data['emoji'] as String?,
      status: IngredientStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => IngredientStatus.pending,
      ),
      defaultUnit: data['default_unit'] as String? ??
          data['defaultUnit'] as String? ??
          'gram',
      caloriesPer100g:
          (data['calories_per_100g'] ?? data['caloriesPer100g'] as num?)
                  ?.toDouble() ??
              0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (emoji != null) 'emoji': emoji,
        'default_unit': defaultUnit,
        'calories_per_100g': caloriesPer100g,
        'status': status.name,
      };
}

enum IngredientStatus { pending, approvad, rejected }
