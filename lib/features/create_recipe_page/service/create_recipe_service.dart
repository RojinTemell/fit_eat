//Firestore servisi

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_eat/core/error/failure.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:flutter/material.dart';
import '../../../core/error/result.dart';
import '../../ingredient/model/ingredient_request.dart';
import 'abstract_recipe_service.dart';

class CreateRecipeService implements IRecipeService {
  CreateRecipeService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  @override
  Future<Result<String>> createRecipe({required RecipeModel model}) async {
    try {
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

      return Success(docRef.id);
    } on FirebaseException catch (e) {
      debugPrint(
        '[CreateRecipeService] Firebase error: ${e.code} ${e.message}',
      );
      return Error(ServerFailure(e.message ?? 'Sunucu hatası'));
    } catch (e) {
      debugPrint('[CreateRecipeService] Unexpected error: $e');
      return const Error(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> suggestIngredient({
    required IngredientRequest model,
  }) async {
    try {
      await _firestore
          .collection('ingredient_suggestions')
          .add(model.toFirestore());
      return const Success(null);
    } on FirebaseException catch (e) {
      debugPrint('[CreateRecipeService] suggestIngredient error: ${e.message}');
      return Error(ServerFailure(e.message ?? 'Öneri gönderilemedi'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Future<Result<List<RecipeModel>>> getAllRecipes() async {
    try {
      final querySnapshot = await _firestore
          .collection('recipes')
          .orderBy('createdAt', descending: true)
          .get();

      final recipes = querySnapshot.docs
          .map((doc) => RecipeModel.fromJson(doc.data()))
          .toList();

      return Success(recipes);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }
}
