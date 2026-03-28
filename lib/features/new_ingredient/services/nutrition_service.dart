import '../../create_recipe_page/model/recipe_model.dart';

class NutritionService {
  NutritionService._(); // instantiate edilemesin

  /// Porsiyon başına kaloriyi hesaplar.
  /// Firestore sorgusu yoktur — tüm veriler RecipeIngredient içinde hazırdır.
  static int calculateCaloriePerServing({required RecipeModel model}) {
    double total = 0;
    print(model.ingredients?.length);
    for (final ing in model.ingredients ?? []) {
      // amount zaten double, parse etmeye gerek yok
      if (ing.amount <= 0 || ing.caloriesPer100g == 0) continue;

      final grams = _toGrams(
        amount: ing.amount,
        unit: ing.unit,
        gramsPerPiece: ing.gramsPerPiece,
      );

      total += ing.caloriesPer100g * (grams / 100);
    }

    final serving = (model.serving ?? 1) > 0 ? model.serving! : 1;
    return total.round();
  }

  static const List<String> units = [
    'gram',
    'kilogram',
    'ml',
    'litre',
    'adet',
    'yemek kaşığı',
    'tatlı kaşığı',
    'çay kaşığı',
    'su bardağı',
    'çay bardağı',
    'tutam',
    'diş',
    'dilim',
    'demet',
    'paket',
    'kutu',
  ];

  /// Birimi gram'a çevirir.
  static double _toGrams({
    required double amount,
    required String unit,
    double? gramsPerPiece,
  }) {
    switch (unit) {
      case 'gram':
        return amount;
      case 'kilogram':
        return amount * 1000;
      case 'ml':
        return amount;
      case 'litre':
        return amount * 1000;
      case 'yemek kaşığı':
        return amount * 15;
      case 'tatlı kaşığı':
        return amount * 10;
      case 'çay kaşığı':
        return amount * 5;
      case 'su bardağı':
        return amount * 200;
      case 'çay bardağı':
        return amount * 100;
      case 'tutam':
        return amount * 1;
      case 'adet':
      case 'diş':
      case 'dilim':
      case 'demet':
      case 'paket':
      case 'kutu':
        return amount * (gramsPerPiece ?? 100);
      default:
        return amount;
    }
  }
}
