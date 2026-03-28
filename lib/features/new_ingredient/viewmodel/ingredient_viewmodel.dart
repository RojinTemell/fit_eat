import 'package:fit_eat/features/new_ingredient/models/ingredient.dart';
import 'package:fit_eat/features/new_ingredient/state/ingredient_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/ingredients_service.dart';

class IngredientViewmodel extends Cubit<IngredientState> {
  IngredientViewmodel()
    : super(
        IngredientState(
          isLoading: false,
          ingredients: [],
          selectedIngredientIds: [],
          defaultIngredients: [],
        ),
      );
  IngredientsService service = IngredientsService();
  Future<void> fetchIngredients() async {
    emit(state.copyWith(isLoading: true));
    List<Ingredient> ingredients = await service.fetchIngredients();

    try {
      emit(
        state.copyWith(
          isLoading: false,
          ingredients: ingredients,
          defaultIngredients: ingredients,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void toggleIngredient(String id) {
    final tempList = List<String>.from(state.selectedIngredientIds);

    if (tempList.contains(id)) {
      tempList.remove(id);
    } else {
      tempList.add(id);
    }

    emit(state.copyWith(selectedIngredientIds: tempList));
  }

  void searchIngredient({required String key}) {
    List<Ingredient> templeList = List.from(state.defaultIngredients);
    templeList.removeWhere((item) {
      return !item.name.toLowerCase().contains(key);
    });
    emit(state.copyWith(ingredients: templeList));
  }

  void clearSearch() {
    emit(state.copyWith(ingredients: state.defaultIngredients));
  }

  void addIngredient() {}
}
