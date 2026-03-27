import 'dart:io';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import '../../ingredient/entities/recipe_ingredient.dart';
import '../../ingredient/model/ingredient_model.dart';
import '../intites/media_rules.dart';
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
      XFile? file;

      if (type == MediaType.image) {
        file = await _picker.pickImage(
          source: source,
          imageQuality: MediaRules.imageQuality,
          maxWidth: MediaRules.maxImageWidth.toDouble(),
        );
      } else {
        file = await _picker.pickVideo(
          source: source,
          maxDuration: MediaRules.maxVideoDuration,
        );
      }

      if (file == null) return;

      final isValid = await _validateMedia(file, type);
      if (!isValid) return;

      List<RecipeMedia> updatedList = List.from(state.mediaList);

      if (type == MediaType.video) {
        updatedList.removeWhere((element) => element.type == MediaType.video);

        updatedList.insert(0, RecipeMedia(file: file, type: type));
      } else {
        updatedList.add(RecipeMedia(file: file, type: type));
      }

      emit(state.copyWith(mediaList: updatedList));
    } catch (e) {
      debugPrint('pickMedia error: $e');
    }
  }

  Future<bool> _validateMedia(XFile file, MediaType type) async {
    final sizeMb = File(file.path).lengthSync() / (1024 * 1024);

    if (type == MediaType.image) {
      if (sizeMb > MediaRules.maxImageSizeMb) {
        debugPrint('Image too large');
        return false;
      }
    }

    if (type == MediaType.video) {
      if (sizeMb > MediaRules.maxVideoSizeMb) {
        debugPrint('Video too large');
        return false;
      }

      final duration = await _getVideoDuration(file.path);
      if (duration > MediaRules.maxVideoDuration) {
        debugPrint('Video duration too long');
        return false;
      }
    }

    return true;
  }

  Future<Duration> _getVideoDuration(String path) async {
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    final duration = controller.value.duration;
    await controller.dispose();
    return duration;
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

  Future<List<Media>> uploadMediaToSupabase() async {
    final supabase = Supabase.instance.client;
    final List<Media> uploaded = [];

    for (final media in state.mediaList) {
      final ext = media.file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';

      final bucket = media.type == MediaType.image ? 'image' : 'video';

      await supabase.storage
          .from(bucket)
          .upload(fileName, File(media.file.path));

      final url = supabase.storage.from(bucket).getPublicUrl(fileName);

      uploaded.add(Media(url: url, type: media.type));
    }

    return uploaded;
  }

  Future<void> createRecipe() async {
    try {
      emit(state.copyWith(isLoading: true));

      final uploadedMedia = await uploadMediaToSupabase();

      final recipe = state.recipe.copyWith(
        media: uploadedMedia,
        createdAt: DateTime.now(),
        viewCount: 0,
        favoriteCount: 0,
        ratingAverage: 0,
        ratingCount: 0,
      );

      await recipeService.createRecipe(model: recipe);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('sendRecipe error: $e');
    }
  }

  int calculateCalorie({required RecipeModel model}) {
    return 0;
  }
}
