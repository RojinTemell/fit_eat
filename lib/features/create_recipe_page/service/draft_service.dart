import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/recipe_model.dart';
import 'abstract_recipe_service.dart';

class DraftRecipeService implements IRecipeDraftService {
  DraftRecipeService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  // Taslağı Kaydet
  Future<void> saveRecipeDraft(String userId, RecipeModel draft) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("drafts")
        .doc("current_recipe")
        .set(draft.toJson());
  }

  // Taslağı Getir
  Future<RecipeModel?> getRecipeDraft(String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('drafts')
        .doc('current_recipe')
        .get();

    if (doc.exists && doc.data() != null) {
      return RecipeModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Taslağı sil
  Future<void> deleteRecipeDraft(String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('drafts')
        .doc('current_recipe')
        .delete();
  }
}
