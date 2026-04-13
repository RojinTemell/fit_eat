import 'package:fit_eat/core/error/failure.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/result.dart';
import '../../ingredient/model/ingredient_request.dart';
import 'abstract_recipe_service.dart';

class CreateRecipeService implements IRecipeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const _pageSize = 20;

  // ─── CREATE ──────────────────────────────────────────────────────────────

  @override
  Future<Result<String>> createRecipe({required RecipeModel model}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return const Error(UnauthorizedFailure());

      final data = model
          .copyWith(
            userId: user.id,
            authorName:
                user.userMetadata?['full_name'] as String? ??
                user.userMetadata?['name'] as String? ??
                'Anonim Şef',
            authorAvatar: user.userMetadata?['avatar_url'] as String?,
          )
          .toSupabase();

      final response = await _supabase
          .from('recipes')
          .insert(data)
          .select('id')
          .single();

      return Success(response['id'] as String);
    } on PostgrestException catch (e) {
      debugPrint('[CreateRecipeService] Postgrest error: ${e.message}');
      return Error(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[CreateRecipeService] Unexpected error: $e');
      return const Error(UnknownFailure());
    }
  }

  // ─── SUGGEST INGREDIENT ──────────────────────────────────────────────────

  @override
  Future<Result<void>> suggestIngredient({
    required IngredientRequest model,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      await _supabase.from('ingredient_suggestions').insert({
        ...model.toJson(),
        if (user != null) 'user_id': user.id,
      });
      return const Success(null);
    } on PostgrestException catch (e) {
      debugPrint('[CreateRecipeService] suggestIngredient error: ${e.message}');
      return Error(ServerFailure(e.message));
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  // ─── FETCH (paginated) ───────────────────────────────────────────────────

  @override
  Future<Result<List<RecipeModel>>> getAllRecipes({DateTime? cursor}) async {
    try {
      // Filters must come before order/limit in Supabase query builder.
      // Join users table to get author display_name and avatar_url.
      var filterQuery = _supabase
          .from('recipes')
          .select('*, users!user_id(display_name, avatar_url)')
          .eq('status', 'published');

      if (cursor != null) {
        filterQuery = filterQuery.lt('created_at', cursor.toIso8601String());
      }

      final response = await filterQuery
          .order('created_at', ascending: false)
          .limit(_pageSize);

      final recipes = (response as List)
          .map((row) => RecipeModel.fromSupabase(row as Map<String, dynamic>))
          .toList();

      return Success(recipes);
    } on PostgrestException catch (e) {
      debugPrint('[CreateRecipeService] getAllRecipes error: ${e.message}');
      return Error(ServerFailure(e.message));
    } catch (e) {
      debugPrint('[CreateRecipeService] getAllRecipes unexpected: $e');
      return const Error(UnknownFailure());
    }
  }
}
