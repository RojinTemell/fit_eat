import 'package:fit_eat/features/ingredient/state/ingredient_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/ingredient_reposiory.dart';

class IngredientViewmodel extends Cubit<IngredientState> {
  final IngredientRepository repository;
  IngredientViewmodel(this.repository) : super(IngredientState.initial());
  Future<void> fetchIngredients() async {
    emit(state.copyWith(isLoading: true));

    try {
      final ingredients = await repository.getIngredients();

      emit(state.copyWith(isLoading: false, ingredients: ingredients));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
