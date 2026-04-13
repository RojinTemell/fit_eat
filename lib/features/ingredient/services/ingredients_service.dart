import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/ingredient_entity.dart';
import '../model/ingredient.dart';

class IngredientsService {
  final _supabase = Supabase.instance.client;

  Future<List<Ingredient>> fetchIngredients() async {
    final response = await _supabase
        .from('ingredients')
        .select()
        .eq('approved', true);

    return (response as List)
        .map((row) => Ingredient.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> seed() async {
    final existing = await _supabase
        .from('ingredients')
        .select('id')
        .limit(1);

    if ((existing as List).isNotEmpty) {
      debugPrint('⚠️  ingredients tablosu zaten dolu, seed atlandı.');
      return;
    }

    const batchSize = 100;
    final data = ingredientDatas;

    for (var i = 0; i < data.length; i += batchSize) {
      final end = (i + batchSize).clamp(0, data.length);
      final rows = data.sublist(i, end).map((row) {
        return {
          'name': row[0],
          'emoji': row[1],
          'default_unit': row[2],
          'calories_per_100g': row[3],
          'protein_per_100g': row[4],
          'fat_per_100g': row[5],
          'carbs_per_100g': row[6],
          if (row.length > 7 && row[7] != null) 'grams_per_piece': row[7],
          'approved': true,
        };
      }).toList();

      await _supabase.from('ingredients').insert(rows);
      debugPrint('✅ $end/${data.length} malzeme yüklendi...');
    }

    debugPrint("🎉 Tüm malzemeler başarıyla Supabase'e yüklendi!");
  }
}
