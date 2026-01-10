import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/abstract_recipe_service.dart';
import '../state/create_recipe_state.dart';

class CreateRecipeViewModel extends Cubit<CreateRecipeState> {
  CreateRecipeViewModel(this.recipeService)
    : super(CreateRecipeState(isLoading: false, recipe: RecipeModel()));
  final IRecipeService recipeService;
  changeLoading({required bool isLoading}) =>
      emit(state.copyWith(isLoading: isLoading));

  void updateTitle(String title) {
    emit(state.copyWith(recipe: state.recipe.copyWith(title: title)));
  }

  void updateAbout(String about) {
    emit(state.copyWith(recipe: state.recipe.copyWith(about: about)));
  }

  void updateDifficulty(String difficulty) {
    emit(state.copyWith(recipe: state.recipe.copyWith(difficulty: difficulty)));
  }

  void updateServing(int serving) {
    emit(state.copyWith(recipe: state.recipe.copyWith(serving: serving)));
  }

  void updateDuration(int duration) {
    emit(state.copyWith(recipe: state.recipe.copyWith(duration: duration)));
  }

  void updateIngredients(List<String> ingredients) {
    emit(
      state.copyWith(recipe: state.recipe.copyWith(ingredients: ingredients)),
    );
  }

  void updateSteps(List<String> steps) {
    emit(state.copyWith(recipe: state.recipe.copyWith(steps: steps)));
  }

  void updateCategories(List<String> categories) {
    emit(state.copyWith(recipe: state.recipe.copyWith(categories: categories)));
  }

  void addImage({required MediaType type, required String url}) {
    final List<Media> tempList = List.from(state.recipe.media ?? []);
    bool isAdded = tempList.any(
      (model) => model.type == type && model.url == url,
    );
    if (!isAdded) {
      tempList.add(Media(type: type, url: url));
    }
    emit(state.copyWith(recipe: state.recipe.copyWith(media: tempList)));
  }

  void removeImage({required MediaType type, required String url}) {
    final List<Media> tempList = List.from(state.recipe.media ?? []);
    tempList.removeWhere((model) => model.type == type && model.url == url);
    emit(state.copyWith(recipe: state.recipe.copyWith(media: tempList)));
  }

  Future<void> sendRecipe({required String userId}) async {
    changeLoading(isLoading: true);
    final RecipeModel model = state.recipe.copyWith(
      calorie: calculateCalorie(model: state.recipe),
      userId: userId,
      createdAt: DateTime.now(),
    );
    await recipeService.createRecipe(model: model);
    changeLoading(isLoading: false);
  }

  //burası yapılacak
  int calculateCalorie({required RecipeModel model}) {
    return 0;
  }
}
