import 'dart:io';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:fit_eat/features/ingredient/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import '../../../core/error/result.dart';
import '../../ingredient/model/ingredient_request.dart';
import '../../ingredient/model/recipe_ingredient.dart';
import '../../ingredient/services/nutrition_service.dart';
import '../intites/media_rules.dart';
import '../model/recipe_media_model.dart';
import '../service/abstract_recipe_service.dart';
import '../state/create_recipe_state.dart';

class CreateRecipeViewModel extends Cubit<CreateRecipeState> {
  CreateRecipeViewModel(
    this.recipeService,
    this.recipeDraftService,
    this.userId,
  ) : super(
        CreateRecipeState(
          isLoading: false,
          recipe: RecipeModel(),
          mediaList: [],
          isDraftChecked: false,
          hasDraftToShow: false,
        ),
      );

  final IRecipeService recipeService;
  final String userId;
  final IRecipeDraftService recipeDraftService;

  final ImagePicker _picker = ImagePicker();
  final Map<String, TextEditingController> ingredientControllers = {};

  //Controllers

  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  final servingController = TextEditingController();
  final durationController = TextEditingController();
  final directionsController = TextEditingController();
  void _initControllerListeners() {
    titleController.addListener(
      () => emit(
        state.copyWith(
          recipe: state.recipe.copyWith(title: titleController.text),
        ),
      ),
    );
    aboutController.addListener(
      () => emit(
        state.copyWith(
          recipe: state.recipe.copyWith(about: aboutController.text),
        ),
      ),
    );
    servingController.addListener(() {
      final v = int.tryParse(servingController.text);
      if (v != null)
        emit(state.copyWith(recipe: state.recipe.copyWith(serving: v)));
    });
    directionsController.addListener(() {
      final v = directionsController.text;
      emit(
        state.copyWith(
          recipe: state.recipe.copyWith(
            steps: v.split('\n').where((e) => e.trim().isNotEmpty).toList(),
          ),
        ),
      );
    });
    durationController.addListener(() {
      final v = int.tryParse(durationController.text);
      if (v != null)
        emit(state.copyWith(recipe: state.recipe.copyWith(duration: v)));
    });
  }

  void clearForm() {
    // Controller'ları önce temizle → listener tetiklenir ama
    // ardından gelen emit zaten boş RecipeModel koyar, sorun olmaz.
    titleController.clear();
    aboutController.clear();
    servingController.clear();
    durationController.clear();
    directionsController.clear();

    for (final c in ingredientControllers.values) {
      c.clear();
    }
    ingredientControllers.clear();

    emit(
      state.copyWith(
        recipe: RecipeModel(),
        mediaList: [],
        isDraftChecked: false,
        isLoading: false,
        hasDraftToShow: false,
      ),
    );
  }

  void _fillFormFromRecipe(RecipeModel recipe) {
    titleController.text = recipe.title ?? '';
    aboutController.text = recipe.about ?? '';
    servingController.text = (recipe.serving ?? '').toString();
    durationController.text = (recipe.duration ?? '').toString();
    directionsController.text = (recipe.steps ?? []).join("\n");

    for (final ingredient in recipe.ingredients ?? []) {
      if (ingredient.id == null) continue;

      // Eski controller'ı dispose etmek yerine, varsa güncelle yoksa oluştur
      if (ingredientControllers.containsKey(ingredient.id)) {
        ingredientControllers[ingredient.id!]?.text =
            (ingredient.amount ?? 0) == 0 ? '' : ingredient.amount.toString();
      } else {
        ingredientControllers[ingredient.id!] = TextEditingController(
          text: (ingredient.amount ?? 0) == 0
              ? ''
              : ingredient.amount.toString(),
        );
      }
    }
  }

  // Upload image or video
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

  Future<List<Media>> uploadMediaToSupabase() async {
    final supabase = Supabase.instance.client;
    final List<Media> uploaded = [];

    for (final media in state.mediaList) {
      try {
        final ext = media.file.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
        final bucket = media.type == MediaType.image ? 'image' : 'video';

        await supabase.storage
            .from(bucket)
            .upload(fileName, File(media.file.path));

        final String url = supabase.storage.from(bucket).getPublicUrl(fileName);
        print("url :${url}");
        uploaded.add(Media(url: url, type: media.type));
      } on StorageException catch (error) {
        print('Supabase Storage Hatası: ${error.message}');

        continue;
      } catch (e) {
        print('Medya yüklenirken beklenmedik hata oluştu: $e');
        continue;
      }
    }

    return uploaded;
  }

  // Ingredient

  void toggleIngredient(Ingredient ingredient) {
    final current = List<RecipeIngredient>.from(state.recipe.ingredients ?? []);

    final index = current.indexWhere((e) => e.id == ingredient.id);

    if (index >= 0) {
      ingredientControllers[ingredient.id]?.dispose();
      ingredientControllers.remove(ingredient.id);
      current.removeAt(index);
    } else {
      ingredientControllers[ingredient.id ?? ""] = TextEditingController();

      current.add(
        RecipeIngredient(
          id: ingredient.id,
          name: ingredient.name,
          unit: ingredient.defaultUnit,
          amount: 0,
          caloriesPer100g: ingredient.caloriesPer100g, // ← bir kere kopyalanır
          gramsPerPiece: ingredient.gramsPerPiece,
        ),
      );
    }

    emit(state.copyWith(recipe: state.recipe.copyWith(ingredients: current)));
  }

  void updateIngredientAmount({
    required String ingredientId,
    required double amount,
  }) {
    final ingredients = List<RecipeIngredient>.from(
      state.recipe.ingredients ?? [],
    );
    final index = ingredients.indexWhere((e) => e.id == ingredientId);
    if (index == -1) return;

    ingredients[index] = ingredients[index].copyWith(amount: amount);
    emit(
      state.copyWith(recipe: state.recipe.copyWith(ingredients: ingredients)),
    );
  }

  void updateIngredientUnit({
    required String ingredientId,
    required String unit,
  }) {
    final ingredients = List<RecipeIngredient>.from(
      state.recipe.ingredients ?? [],
    );
    final index = ingredients.indexWhere((e) => e.id == ingredientId);
    if (index == -1) return;

    ingredients[index] = ingredients[index].copyWith(unit: unit);
    emit(
      state.copyWith(recipe: state.recipe.copyWith(ingredients: ingredients)),
    );
  }

  void removeIngredient(String ingredientId) {
    ingredientControllers[ingredientId]?.dispose();
    ingredientControllers.remove(ingredientId);
    final ingredients = List<RecipeIngredient>.from(
      state.recipe.ingredients ?? [],
    )..removeWhere((e) => e.id == ingredientId);

    emit(
      state.copyWith(recipe: state.recipe.copyWith(ingredients: ingredients)),
    );
  }

  Future<void> suggestIngredient({
    required String title,
    String? caloriesPer100g,

    required String defaultUnit,
  }) async {
    final data = IngredientRequest(
      id: null,
      name: title,
      status: IngredientStatus.pending,
      emoji: "",
      defaultUnit: defaultUnit,
      caloriesPer100g: double.tryParse(caloriesPer100g ?? "") ?? 0,
    );
    print(data.toFirestore());

    await recipeService.suggestIngredient(model: data);
  }

  // others
  void toggleCategory(String id) {
    final categories = List<String>.from(state.recipe.categories ?? []);
    if (categories.contains(id)) {
      categories.remove(id);
    } else {
      categories.add(id);
    }
    emit(state.copyWith(recipe: state.recipe.copyWith(categories: categories)));
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

  int calculateCalorie({required RecipeModel model}) {
    return NutritionService.calculateCaloriePerServing(model: model);
  }

  Future<void> createRecipe() async {
    try {
      emit(state.copyWith(isLoading: true));

      final uploadedMedia = await uploadMediaToSupabase();
      final calorie = calculateCalorie(model: state.recipe);

      final recipe = state.recipe.copyWith(
        userId: userId,
        media: uploadedMedia,
        calorie: calorie,
        createdAt: DateTime.now(),
        viewCount: 0,
        favoriteCount: 0,
        ratingAverage: 0,
        ratingCount: 0,
      );

      await recipeService.createRecipe(model: recipe);
      clearForm();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('sendRecipe error: $e');
    }
  }

  // draft features
  // Future<void> checkAndLoadDraft() async {
  //   try {
  //     changeLoading(isLoading: true);
  //     final Result<RecipeModel?> draft = await recipeDraftService.getRecipeDraft(userId);

  //     if (draft != null) {
  //       _fillFormFromRecipe(draft);
  //       emit(
  //         state.copyWith(
  //           recipe: draft,
  //           isDraftChecked: true,
  //           isLoading: false,
  //           hasDraftToShow: true,
  //         ),
  //       );
  //       // NOT: UI tarafında "Taslaktan devam edilsin mi?" sorusunu bu state değişikliğiyle tetikleyeceğiz.
  //     } else {
  //       emit(state.copyWith(isDraftChecked: true, isLoading: false));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(isDraftChecked: true, isLoading: false));
  //     debugPrint('Draft load error: $e');
  //   }
  // }

  Future<void> discardDraft() async {
    try {
      await recipeDraftService.deleteRecipeDraft(userId);
      clearForm();
      debugPrint('Taslak başarıyla silindi ve form sıfırlandı.');
    } catch (e) {
      debugPrint('Discard draft error: $e');
    }
  }

  void draftDialogShown() {
    emit(state.copyWith(hasDraftToShow: false));
  }

  Future<void> saveAsDraft() async {
    //  title boşsa VE ingredients boşsa kaydetme
    final hasTitle = state.recipe.title?.trim().isNotEmpty == true;
    final hasIngredients = state.recipe.ingredients?.isNotEmpty == true;
    if (!hasTitle && !hasIngredients) return;
    try {
      await recipeDraftService.saveRecipeDraft(userId, state.recipe);
      debugPrint("Taslak kaydedildi.");
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    aboutController.dispose();
    servingController.dispose();
    durationController.dispose();
    directionsController.dispose();
    for (final c in ingredientControllers.values) {
      c.dispose();
    }
    return super.close();
  }
}
