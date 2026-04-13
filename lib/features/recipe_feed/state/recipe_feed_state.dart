import 'package:equatable/equatable.dart';
import 'package:fit_eat/core/feedback/app_feedback.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';

import '../../../core/feedback/feedback_cubit_mixin.dart';

class RecipeFeedState extends Equatable implements HasFeedback {
  const RecipeFeedState({
    required this.isLoading,
    this.feedback,
    required this.recipes,
    this.cursor,
    this.hasMore = true,
  });

  final bool isLoading;

  @override
  final AppFeedback? feedback;

  final List<RecipeModel> recipes;

  /// The [createdAt] of the last loaded recipe — passed as cursor for the next page.
  final DateTime? cursor;

  /// False when the last page returned fewer items than the page size.
  final bool hasMore;

  @override
  List<Object?> get props => [feedback, isLoading, recipes, cursor, hasMore];

  @override
  RecipeFeedState withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);

  RecipeFeedState copyWith({
    bool? isLoading,
    List<RecipeModel>? recipes,
    DateTime? cursor,
    bool? hasMore,
    Object? feedback = _absent,
  }) =>
      RecipeFeedState(
        isLoading: isLoading ?? this.isLoading,
        recipes: recipes ?? this.recipes,
        cursor: cursor ?? this.cursor,
        hasMore: hasMore ?? this.hasMore,
        feedback: identical(feedback, _absent)
            ? this.feedback
            : feedback as AppFeedback?,
      );
}

const Object _absent = Object();
