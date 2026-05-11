import 'package:fit_eat/features/recipe_feed/service/abstract_recipe_feed_service.dart';
import 'package:fit_eat/features/recipe_feed/state/category_state.dart';
import 'package:flutter/material.dart';
import '../../../core/feedback/feedback_listener.dart';
import '../service/recipe_feed_service.dart';

final class CategoryViewModel extends FeedbackCubit<CategoryState> {
  CategoryViewModel() : super(CategoryState(categories: [], isLoading: false));
  final IRecipeFeedService _recipeFeedService = RecipeFeedService();
  void getCategories() async {
    emit(state.copyWith(isLoading: true, categories: []));
    final result = await _recipeFeedService.getCategories();

    await handleResult(
      result,
      onSuccess: (data) =>
          emit(state.copyWith(categories: data, isLoading: false)),
    );

    if (state.isLoading) emit(state.copyWith(isLoading: false));
    debugPrint('[RecipeFeed] loaded ${state.categories.length} categories');
  }
}
