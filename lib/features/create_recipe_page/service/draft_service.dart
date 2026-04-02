import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../model/recipe_model.dart';
import 'abstract_recipe_service.dart';

class DraftRecipeService implements IRecipeDraftService {
  DraftRecipeService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const _draftsCollection = 'drafts';
  static const _currentDraftDoc = 'current_recipe';

  DocumentReference<Map<String, dynamic>> _draftRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection(_draftsCollection)
      .doc(_currentDraftDoc);

  // Taslağı Kaydet
  @override
  Future<Result<void>> saveRecipeDraft(String userId, RecipeModel draft) async {
    try {
      await _draftRef(userId).set(draft.toJson());
      return const Success(null);
    } on FirebaseException catch (e) {
      debugPrint('[DraftService] save error: ${e.message}');
      return Error(ServerFailure(e.message ?? 'Taslak kaydedilemedi'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // Taslağı Getir
  @override
  Future<Result<RecipeModel?>> getRecipeDraft(String userId) async {
    try {
      final doc = await _draftRef(userId).get();
      if (!doc.exists || doc.data() == null) return const Success(null);
      return Success(RecipeModel.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      debugPrint('[DraftService] get error: ${e.message}');
      return Error(ServerFailure(e.message ?? 'Taslak yüklenemedi'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // Taslağı sil
  @override
  Future<Result<void>> deleteRecipeDraft(String userId) async {
    try {
      await _draftRef(userId).delete();
      return const Success(null);
    } on FirebaseException catch (e) {
      debugPrint('[DraftService] delete error: ${e.message}');
      return Error(ServerFailure(e.message ?? 'Taslak silinemedi'));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }
}
