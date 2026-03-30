//Firestore servisi

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import '../../ingredient/model/ingredient_request.dart';
import 'abstract_recipe_service.dart';

class CreateRecipeService implements IRecipeService {
  CreateRecipeService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<String> createRecipe({required RecipeModel model}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Kullanıcı girişi yapılmamış!");
    final docRef = _firestore.collection('recipes').doc();
    final enrichedData = model
        .copyWith(
          id: docRef.id,
          userId: user.uid,
          authorName: user.displayName ?? "Anonim Şef",
          authorAvatar: user.photoURL,
        )
        .toJson();

    await docRef.set({
      ...enrichedData,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _updateUserStats(user.uid);

    return docRef.id;
  }

  Future<void> _updateUserStats(String uid) async {
    await _firestore.collection('users').doc(uid).set({
      'recipeCount': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> suggestIngredient({required IngredientRequest model}) async {
    try {
      await _firestore
          .collection('ingredient_suggestions')
          .add(model.toFirestore());
      print("Öneri başarıyla gönderildi!");
    } catch (e) {
      print("Öneri gönderilirken hata oluştu: $e");
      rethrow;
    }
  }
}
