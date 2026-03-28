import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_eat/features/new_ingredient/models/ingredient.dart';

import '../seed/ingredient_seeder.dart';

class IngredientsService {
  Future<List<Ingredient>> fetchIngredients() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ingredients')
        .where('approved', isEqualTo: true)
        .get();

    final ingredients = snapshot.docs
        .map((doc) => Ingredient.fromFirestore(doc))
        .toList();
    return ingredients;
  }

  final _data = ingredientDatas;
  Future<void> seed() async {
    final collection = FirebaseFirestore.instance.collection('ingredients');

    // Zaten veri varsa yükleme (çift kayıt önleme)
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('⚠️  ingredients koleksiyonu zaten dolu, seed atlandı.');
      return;
    }

    // 500'lük Firestore batch limiti nedeniyle parçalara böl
    const batchSize = 100;
    for (var i = 0; i < _data.length; i += batchSize) {
      final chunk = _data.sublist(
        i,
        i + batchSize > _data.length ? _data.length : i + batchSize,
      );

      final batch = FirebaseFirestore.instance.batch();
      for (final row in chunk) {
        final ref = collection.doc();
        batch.set(ref, {
          'name': row[0],
          'emoji': row[1],
          'defaultUnit': row[2],
          'caloriesPer100g': row[3],
          'proteinPer100g': row[4],
          'fatPer100g': row[5],
          'carbsPer100g': row[6],
          if (row[7] != null) 'gramsPerPiece': row[7],
          'approved': true,
        });
      }
      await batch.commit();
      print('✅ ${i + chunk.length}/${_data.length} malzeme yüklendi...');
    }

    print('🎉 Tüm malzemeler başarıyla Firebase\'e yüklendi!');
  }
}
