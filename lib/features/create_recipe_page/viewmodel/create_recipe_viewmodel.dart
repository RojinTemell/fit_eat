import 'dart:io';

import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../ingredient/entities/recipe_ingredient.dart';
import '../../ingredient/model/ingredient_model.dart';
import '../model/recipe_media_model.dart';
import '../service/abstract_recipe_service.dart';
import '../state/create_recipe_state.dart';

class CreateRecipeViewModel extends Cubit<CreateRecipeState> {
  CreateRecipeViewModel(this.recipeService)
    : super(
        CreateRecipeState(
          isLoading: false,
          recipe: RecipeModel(),
          mediaList: [],
        ),
      );

  final IRecipeService recipeService;

  final ImagePicker _picker = ImagePicker();
  Future<void> pickMedia(MediaType type, ImageSource source) async {
    try {
      XFile? pickedFile;

      if (type == MediaType.image) {
        pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1920,
        );
      } else {
        pickedFile = await _picker.pickVideo(
          source: source,
          maxDuration: const Duration(minutes: 2),
        );
      }

      if (pickedFile == null) return;

      if (!_validateMedia(pickedFile, type)) return;

      final media = RecipeMedia(file: pickedFile, type: type);

      emit(state.copyWith(mediaList: [...state.mediaList, media]));
    } catch (e) {
      debugPrint('pickMedia error: $e');
    }
  }

  bool _validateMedia(XFile file, MediaType type) {
    final sizeMb = File(file.path).lengthSync() / (1024 * 1024);

    if (type == MediaType.image && sizeMb > 5) {
      debugPrint('Image size too large');
      return false;
    }

    if (type == MediaType.video && sizeMb > 50) {
      debugPrint('Video size too large');
      return false;
    }

    return true;
  }

  void removeMedia(RecipeMedia media) {
    emit(
      state.copyWith(
        mediaList: state.mediaList.where((e) => e != media).toList(),
      ),
    );
  }

  void toggleCategory(String id) {
    final categories = List<String>.from(state.recipe.categories ?? []);
    if (categories.contains(id)) {
      categories.remove(id);
    } else {
      categories.add(id);
    }
    emit(state.copyWith(recipe: state.recipe.copyWith(categories: categories)));
  }

  void toggleIngredient(IngredientModel ingredient) {
    final current = List<RecipeIngredient>.from(state.recipe.ingredients ?? []);

    final index = current.indexWhere((e) => e.ingredientId == ingredient.id);

    if (index >= 0) {
      // çıkar
      current.removeAt(index);
    } else {
      // ekle (quantity boş başlar)
      current.add(
        RecipeIngredient(
          ingredientId: ingredient.id,
          name: ingredient.name,
          quantity: '',
          unit: ingredient.defaultUnit,
        ),
      );
    }

    emit(state.copyWith(recipe: state.recipe.copyWith(ingredients: current)));
  }

  void updateIngredientQuantity({
    required String ingredientId,
    required String quantity,
  }) {
    final ingredients = List<RecipeIngredient>.from(
      state.recipe.ingredients ?? [],
    );

    final index = ingredients.indexWhere((e) => e.ingredientId == ingredientId);

    if (index == -1) return;

    final old = ingredients[index];

    ingredients[index] = old.copyWith(quantity: quantity);

    emit(
      state.copyWith(recipe: state.recipe.copyWith(ingredients: ingredients)),
    );
  }

  void removeIngredient(String ingredientId) {
    final ingredients = List<RecipeIngredient>.from(
      state.recipe.ingredients ?? [],
    )..removeWhere((e) => e.ingredientId == ingredientId);

    emit(
      state.copyWith(recipe: state.recipe.copyWith(ingredients: ingredients)),
    );
  }

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

  void updateSteps(List<String> steps) {
    emit(state.copyWith(recipe: state.recipe.copyWith(steps: steps)));
  }

  void updateCategories(List<String> categories) {
    emit(state.copyWith(recipe: state.recipe.copyWith(categories: categories)));
  }

  // void addImage({required MediaType type, required String url}) {
  //   final List<Media> tempList = List.from(state.recipe.media ?? []);
  //   bool isAdded = tempList.any(
  //     (model) => model.type == type && model.url == url,
  //   );
  //   if (!isAdded) {
  //     tempList.add(Media(type: type, url: url));
  //   }
  //   emit(state.copyWith(recipe: state.recipe.copyWith(media: tempList)));
  // }

  // void removeImage({required MediaType type, required String url}) {
  //   final List<Media> tempList = List.from(state.recipe.media ?? []);
  //   tempList.removeWhere((model) => model.type == type && model.url == url);
  //   emit(state.copyWith(recipe: state.recipe.copyWith(media: tempList)));
  // }

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
