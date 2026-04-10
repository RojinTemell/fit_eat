import 'package:fit_eat/core/feedback/feedback_listener.dart';
import 'package:fit_eat/features/recipe_feed/state/recipe_feed_state.dart';

import '../../create_recipe_page/service/abstract_recipe_service.dart';

class RecipeFeedViewmodel extends FeedbackCubit<RecipeFeedState> {
  RecipeFeedViewmodel(this.recipeService)
    : super(RecipeFeedState(isLoading: false, recipes: []));
  final IRecipeService recipeService;
  void changeLoading() => emit(state.copyWith(isLoading: !state.isLoading));

  Future<void> getAllRecipes() async {
    changeLoading();
    final result = await recipeService.getAllRecipes();
    await handleResult(
      result,
      onSuccess: (data) => emit(state.copyWith(recipes: data)),
    );
    print("recipes count ${state.recipes.length}");
    changeLoading();
  }
}
