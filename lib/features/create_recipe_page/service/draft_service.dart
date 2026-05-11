import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../model/recipe_model.dart';
import 'abstract_recipe_service.dart';

/// Stores the in-progress recipe draft locally using SharedPreferences.
/// No cloud sync needed — drafts are personal and temporary.
class DraftRecipeService implements IRecipeDraftService {
  static const _keyPrefix = 'recipe_draft_';

  @override
  Future<Result<void>> saveRecipeDraft(String userId, RecipeModel draft) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyPrefix + userId, jsonEncode(draft.toJson()));
      return const Ok(null);
    } catch (e) {
      debugPrint('[DraftService] save error: $e');
      return  Err(UnknownFailure());
    }
  }

  @override
  Future<Result<RecipeModel?>> getRecipeDraft(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyPrefix + userId);
      if (raw == null) return const Ok(null);
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Ok(RecipeModel.fromJson(map));
    } catch (e) {
      debugPrint('[DraftService] get error: $e');
      return  Err(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> deleteRecipeDraft(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyPrefix + userId);
      return const Ok(null);
    } catch (e) {
      debugPrint('[DraftService] delete error: $e');
      return  Err(UnknownFailure());
    }
  }
}
