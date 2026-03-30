import 'package:equatable/equatable.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import '../model/recipe_media_model.dart';

class CreateRecipeState extends Equatable {
  const CreateRecipeState({
    required this.isLoading,
    required this.recipe,
    required this.mediaList,
    required this.isDraftChecked,
    required this.hasDraftToShow,
    this.errorMessage,
  });

  final bool isLoading;
  final RecipeModel recipe;
  final List<RecipeMedia> mediaList;
  final String? errorMessage;
  final bool isDraftChecked;
  final bool hasDraftToShow;

  @override
  List<Object?> get props => [
    isLoading,
    recipe,
    mediaList,
    errorMessage,
    isDraftChecked,
    hasDraftToShow,
  ];
  bool get hasFormData =>
      recipe.title?.trim().isNotEmpty == true ||
      recipe.ingredients?.isNotEmpty == true;

  CreateRecipeState copyWith({
    bool? isLoading,
    RecipeModel? recipe,
    List<RecipeMedia>? mediaList,
    String? errorMessage,
    bool? isDraftChecked,
    bool? hasDraftToShow,
  }) => CreateRecipeState(
    isLoading: isLoading ?? this.isLoading,
    recipe: recipe ?? this.recipe,
    mediaList: mediaList ?? this.mediaList,
    errorMessage: errorMessage ?? this.errorMessage,
    isDraftChecked: isDraftChecked ?? this.isDraftChecked,
    hasDraftToShow: hasDraftToShow ?? this.hasDraftToShow,
  );
}
