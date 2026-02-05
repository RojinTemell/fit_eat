import 'package:fit_eat/features/ingredient/state/ingredient_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/ingredient_model.dart';
import '../repository/ingredient_reposiory.dart';

class IngredientViewmodel extends Cubit<IngredientState> {
  final IngredientRepository repository;
  IngredientViewmodel(this.repository) : super(IngredientState.initial());
  Future<void> fetchIngredients() async {
    emit(state.copyWith(isLoading: true));

    try {
      final ingredients = await repository.getIngredients();

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
    List<IngredientModel> templeList = List.from(
      state.defaultIngredients ?? [],
    );
    templeList.removeWhere((item) {
      print(item.name.toLowerCase());
      return !item.name.toLowerCase().contains(key);
    });
    emit(state.copyWith(ingredients: templeList));
  }

  void clearSearch() {
    emit(state.copyWith(ingredients: state.defaultIngredients));
  }

  void addIngredient() {}
}
