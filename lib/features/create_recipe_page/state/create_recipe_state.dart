import 'package:equatable/equatable.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';

class CreateRecipeState extends Equatable {
  const CreateRecipeState({required this.isLoading, required this.recipe});
  final bool isLoading;
  final RecipeModel recipe;

  @override
  List<Object?> get props => [isLoading, recipe];
  CreateRecipeState copyWith({bool? isLoading, RecipeModel? recipe}) =>
      CreateRecipeState(
        isLoading: isLoading ?? this.isLoading,
        recipe: recipe ?? this.recipe,
      );
}
