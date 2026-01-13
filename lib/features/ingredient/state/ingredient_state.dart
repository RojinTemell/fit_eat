import 'package:equatable/equatable.dart';
import 'package:fit_eat/features/ingredient/model/ingredient_model.dart';

class IngredientState extends Equatable {
  const IngredientState({required this.isLoading, required this.ingredients});
  final bool isLoading;
  final List<IngredientModel> ingredients;
  factory IngredientState.initial() {
    return const IngredientState(isLoading: false, ingredients: []);
  }
  @override
  List<Object?> get props => [isLoading, ingredients];
  IngredientState copyWith({
    bool? isLoading,
    List<IngredientModel>? ingredients,
  }) => IngredientState(
    isLoading: isLoading ?? this.isLoading,
    ingredients: ingredients ?? this.ingredients,
  );
}
