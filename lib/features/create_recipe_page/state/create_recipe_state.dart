import 'package:equatable/equatable.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_cubit_mixin.dart';
import '../model/recipe_media_model.dart';

class CreateRecipeState extends Equatable implements HasFeedback {
  const CreateRecipeState({
    required this.isLoading,
    required this.recipe,
    required this.mediaList,
    required this.isDraftChecked,
    required this.hasDraftToShow,
    this.feedback,
  });

  final bool isLoading;
  final RecipeModel recipe;
  final List<RecipeMedia> mediaList;
  final bool isDraftChecked;
  final bool hasDraftToShow;

  @override
  final AppFeedback? feedback;

  @override
  List<Object?> get props => [
    isLoading,
    recipe,
    mediaList,
    isDraftChecked,
    hasDraftToShow,
    feedback,
  ];

  bool get hasFormData =>
      recipe.title?.trim().isNotEmpty == true ||
      recipe.ingredients?.isNotEmpty == true;
  @override
  CreateRecipeState withFeedback(AppFeedback? feedback) =>
      copyWith(feedback: feedback);
  CreateRecipeState copyWith({
    bool? isLoading,
    RecipeModel? recipe,
    List<RecipeMedia>? mediaList,
    String? errorMessage,
    bool? isDraftChecked,
    bool? hasDraftToShow,
    Object? feedback = _absent,
  }) => CreateRecipeState(
    isLoading: isLoading ?? this.isLoading,
    recipe: recipe ?? this.recipe,
    mediaList: mediaList ?? this.mediaList,

    isDraftChecked: isDraftChecked ?? this.isDraftChecked,
    hasDraftToShow: hasDraftToShow ?? this.hasDraftToShow,
    feedback: identical(feedback, _absent)
        ? this.feedback
        : feedback as AppFeedback?,
  );
}

const Object _absent = Object();
