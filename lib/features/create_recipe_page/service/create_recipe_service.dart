//Firestore servisi

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';

import 'abstract_recipe_service.dart';

class CreateRecipeService implements IRecipeService {
  CreateRecipeService({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<void> createRecipe({required RecipeModel model}) async {
    await firestore.collection('recipes').add(model.toJson());
  }
}
