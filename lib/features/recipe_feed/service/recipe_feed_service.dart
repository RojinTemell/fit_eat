import 'package:fit_eat/core/error/result.dart';
import 'package:fit_eat/features/recipe_feed/model/category_model.dart';
import 'package:fit_eat/features/recipe_feed/service/abstract_recipe_feed_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/error/failure.dart';

final class RecipeFeedService implements IRecipeFeedService {
  final SupabaseClient _supabase = Supabase.instance.client;
  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .order('sort_order', ascending: true);

      List<CategoryModel> result = response
          .map((data) => CategoryModel.fromJson(data))
          .toList();
      return Ok(result);
    } on PostgrestException catch (e) {
      debugPrint('[RecipeFeedService] getCategories error: ${e.message}');
      return Err(ServerFailure());
    } catch (e) {
      debugPrint('[RecipeFeedService] getCategories unexpected: $e');
      return Err(UnknownFailure());
    }
  }
}
