import 'package:equatable/equatable.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';

import '../model/recipe_media_model.dart';

class CreateRecipeState extends Equatable {
  const CreateRecipeState({
    required this.isLoading,
    required this.recipe,
    required this.mediaList,
  });
  final bool isLoading;
  final RecipeModel recipe;
  final List<RecipeMedia> mediaList;

  @override
  List<Object?> get props => [isLoading, recipe, mediaList];
  CreateRecipeState copyWith({
    bool? isLoading,
    RecipeModel? recipe,
    List<RecipeMedia>? mediaList,
  }) => CreateRecipeState(
    isLoading: isLoading ?? this.isLoading,
    recipe: recipe ?? this.recipe,
    mediaList: mediaList ?? this.mediaList,
  );
}
