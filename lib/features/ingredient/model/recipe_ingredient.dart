import 'package:uuid/uuid.dart';
class RecipeIngredient {
  final String id;
  final String name;
  final double amount;
  final String unit;

  RecipeIngredient({
    String? id,
    required this.name,
    required this.amount,
    required this.unit,
  }) : id = id ?? const Uuid().v4();

  factory RecipeIngredient.fromJson(Map<String, dynamic> data) {
    return RecipeIngredient(
      name: data['name'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      unit: data['unit'] as String? ?? 'gram',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  RecipeIngredient copyWith({
    double? amount,
    String? unit,
  }) {
    return RecipeIngredient(
      id: id,
      name: name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }
}
