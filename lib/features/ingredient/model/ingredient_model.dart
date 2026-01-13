import '../entities/ingredient.dart';

class IngredientModel extends Ingredient {
  // final String? image;
  IngredientModel({
    required super.name,
    required super.category,
    required super.id,
    super.image,
    required super.allowedUnits,
    required super.defaultUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'id': id,
      'image': image,
      'allowedUnits': allowedUnits,
      'defaultUnit': defaultUnit,
    };
  }

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      id: json['id'] ?? '',
      image: json['image'],
      allowedUnits: List<String>.from(json['allowedUnits'] ?? []),
      defaultUnit: json['defaultUnit'] ?? '',
    );
  }
}
