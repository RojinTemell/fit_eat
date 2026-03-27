//Firestore servisi

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';

import 'abstract_recipe_service.dart';

class CreateRecipeService implements IRecipeService {
  CreateRecipeService({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<String> createRecipe({required RecipeModel model}) async {
    final docRef = firestore.collection('recipes').doc();

    final data = model.copyWith(createdAt: DateTime.now()).toJson();

    await docRef.set({
      ...data,
      'id': docRef.id,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }
}
