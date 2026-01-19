import 'package:equatable/equatable.dart';
import 'package:fit_eat/features/ingredient/model/ingredient_model.dart';

class IngredientState extends Equatable {
  const IngredientState({
    required this.isLoading,
    required this.ingredients,
    required this.selectedIngredientIds,
  });
  final bool isLoading;
  final List<IngredientModel> ingredients;
  final List<String> selectedIngredientIds;
  factory IngredientState.initial() {
    return const IngredientState(
      isLoading: false,
      ingredients: [],
      selectedIngredientIds: [],
    );
  }
  @override
  List<Object?> get props => [isLoading, ingredients, selectedIngredientIds];
  IngredientState copyWith({
    bool? isLoading,
    List<IngredientModel>? ingredients,
    List<String>? selectedIngredientIds,
  }) => IngredientState(
    isLoading: isLoading ?? this.isLoading,
    ingredients: ingredients ?? this.ingredients,
    selectedIngredientIds: selectedIngredientIds ?? this.selectedIngredientIds,
  );
}
