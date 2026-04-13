import 'package:fit_eat/core/feedback/feedback_listener.dart';
import 'package:fit_eat/features/recipe_feed/state/recipe_feed_state.dart';
import 'package:flutter/foundation.dart';

import '../../create_recipe_page/service/abstract_recipe_service.dart';

class RecipeFeedViewmodel extends FeedbackCubit<RecipeFeedState> {
  RecipeFeedViewmodel(this._recipeService)
      : super(const RecipeFeedState(isLoading: false, recipes: []));

  final IRecipeService _recipeService;

  static const _pageSize = 20;

  /// Loads the first page, replacing any existing feed data.
  Future<void> getAllRecipes() async {
    emit(state.copyWith(isLoading: true, recipes: [], hasMore: true));

    final result = await _recipeService.getAllRecipes();

    await handleResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          recipes: data,
          cursor: data.isNotEmpty ? data.last.createdAt : null,
          hasMore: data.length >= _pageSize,
          isLoading: false,
        ),
      ),
    );

    if (state.isLoading) emit(state.copyWith(isLoading: false));
    debugPrint('[RecipeFeed] loaded ${state.recipes.length} recipes');
  }

  /// Appends the next page to the existing list using the stored cursor.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    final result = await _recipeService.getAllRecipes(cursor: state.cursor);

    await handleResult(
      result,
      onSuccess: (data) => emit(
        state.copyWith(
          recipes: [...state.recipes, ...data],
          cursor: data.isNotEmpty ? data.last.createdAt : state.cursor,
          hasMore: data.length >= _pageSize,
          isLoading: false,
        ),
      ),
    );

    if (state.isLoading) emit(state.copyWith(isLoading: false));
  }
}
