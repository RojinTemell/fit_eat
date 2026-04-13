import 'dart:async';
import 'dart:io';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:fit_eat/features/ingredient/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../core/feedback/app_feedback.dart';
import '../../../core/feedback/feedback_listener.dart';
import '../../ingredient/model/ingredient_request.dart';
import '../../ingredient/model/recipe_ingredient.dart';
import '../../ingredient/services/nutrition_service.dart';
import '../intites/media_rules.dart';
import '../model/recipe_media_model.dart';
import '../../../core/error/result.dart';
import '../service/abstract_media_service.dart';
import '../service/abstract_recipe_service.dart';
import '../state/create_recipe_state.dart';

class CreateRecipeViewModel extends FeedbackCubit<CreateRecipeState> {
  CreateRecipeViewModel(
    this.recipeService,
    this.recipeDraftService,
    this.mediaService,
    this.userId,
  ) : super(
        CreateRecipeState(
          isLoading: false,
          recipe: RecipeModel(),
          mediaList: [],
          isDraftChecked: false,
          hasDraftToShow: false,
        ),
      ) {
    _initControllerListeners();
  }

  final IRecipeService recipeService;
  final IRecipeDraftService recipeDraftService;
  final IMediaService mediaService;
  final String userId;

  final ImagePicker _picker = ImagePicker();
  final Map<String, TextEditingController> ingredientControllers = {};

  // Controllers
  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  final servingController = TextEditingController();
  final durationController = TextEditingController();
  final directionsController = TextEditingController();

  void _initControllerListeners() {
    _bindText(titleController, (r, v) => r.copyWith(title: v));
    _bindText(aboutController, (r, v) => r.copyWith(about: v));
    _bindParsedInt(servingController, (r, v) => r.copyWith(serving: v));
    _bindParsedInt(durationController, (r, v) => r.copyWith(duration: v));
    directionsController.addListener(() {
      final steps = directionsController.text
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();
      emit(state.copyWith(recipe: state.recipe.copyWith(steps: steps)));
    });
  }

  void _bindText(
    TextEditingController ctrl,
    RecipeModel Function(RecipeModel recipe, String text) update,
  ) {
    ctrl.addListener(
      () => emit(state.copyWith(recipe: update(state.recipe, ctrl.text))),
    );
  }

  void _bindParsedInt(
    TextEditingController ctrl,
    RecipeModel Function(RecipeModel recipe, int? value) update,
  ) {
    ctrl.addListener(
      () => emit(
        state.copyWith(recipe: update(state.recipe, int.tryParse(ctrl.text))),
      ),
    );
  }

  // ─── RECIPE ───────────────────────────────────────────────────────────────

  Future<void> createRecipe() async {
    if ((state.recipe.categories ?? []).isEmpty) {
      emitFeedback(const ErrorFeedback('Lütfen en az bir kategori seçin.'));
      return;
    }

    // 2. Malzeme Kontrolü
    final ingredients = state.recipe.ingredients ?? [];
    if (ingredients.isEmpty) {
      emitFeedback(const ErrorFeedback('Lütfen en az bir malzeme ekleyin.'));
      return;
    }

    // 3. Malzeme Miktarı (Amount) Kontrolü
    final hasEmptyAmount = ingredients.any((e) => (e.amount ?? 0) <= 0);
    if (hasEmptyAmount) {
      emitFeedback(
        const ErrorFeedback('Lütfen tüm malzemelerin miktarını giriniz.'),
      );
      return;
    }
    emit(state.copyWith(isLoading: true));

    try {
      final mediaResult = await mediaService.uploadMedia(state.mediaList);
      if (mediaResult.isError) {
        emitFeedback(ErrorFeedback(mediaResult.failureOrNull!.message));
        emit(state.copyWith(isLoading: false));
        return;
      }
      final uploadedMedia = mediaResult.dataOrNull!;
      final calorie = NutritionService.calculateCaloriePerServing(
        model: state.recipe,
      );
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
      print("Recipe içeriği  ${recipe.toJson()}");
      final result = await recipeService.createRecipe(model: recipe);

      await handleResult(
        result,
        successMessage: 'Tarif başarıyla yayınlandı!',
        onSuccess: (_) => clearForm(),
      );
    } catch (e) {
      debugPrint('createRecipe unexpected error: $e');
      emitFeedback(const ErrorFeedback('Beklenmeyen bir hata oluştu.'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  // ─── DRAFT ────────────────────────────────────────────────────────────────

  Future<void> checkAndLoadDraft() async {
    emit(state.copyWith(isLoading: true));

    final result = await recipeDraftService.getRecipeDraft(userId);

    await handleResult<RecipeModel?>(
      result,
      onSuccess: (draft) {
        if (draft != null) {
          _fillFormFromRecipe(draft);
          emit(
            state.copyWith(
              recipe: draft,
              isDraftChecked: true,
              hasDraftToShow: true,
              isLoading: false,
            ),
          );
        } else {
          emit(state.copyWith(isDraftChecked: true, isLoading: false));
        }
      },
    );

    if (state.isLoading) {
      emit(state.copyWith(isDraftChecked: true, isLoading: false));
    }
  }

  Future<void> saveAsDraft() async {
    final hasTitle = state.recipe.title?.trim().isNotEmpty == true;
    final hasIngredients = state.recipe.ingredients?.isNotEmpty == true;
    if (!hasTitle && !hasIngredients) return;

    final result = await recipeDraftService.saveRecipeDraft(
      userId,
      state.recipe,
    );

    await handleResult(result, successMessage: 'Taslak kaydedildi.');
  }

  Future<void> discardDraft() async {
    final result = await recipeDraftService.deleteRecipeDraft(userId);

    await handleResult(result, onSuccess: (_) => clearForm());
  }

  void draftDialogShown() => emit(state.copyWith(hasDraftToShow: false));

  // ─── SUGGEST INGREDIENT ──────────────────────────────────────────────────

  Future<void> suggestIngredient({
    required String title,
    String? caloriesPer100g,
    String? defaultUnit,
  }) async {
    final data = IngredientRequest(
      id: null,
      name: title,
      status: IngredientStatus.pending,

      defaultUnit: defaultUnit ?? "gram",
      caloriesPer100g: double.tryParse(caloriesPer100g ?? '') ?? 0,
    );

    final result = await recipeService.suggestIngredient(model: data);

    await handleResult(result, successMessage: 'Önerin iletildi, teşekkürler!');
  }

  // ─── INGREDIENT ──────────────────────────────────────────────────────────

  void toggleIngredient(Ingredient ingredient) {
    final current = List<RecipeIngredient>.from(state.recipe.ingredients ?? []);
    final index = current.indexWhere((e) => e.id == ingredient.id);

    if (index >= 0) {
      ingredientControllers[ingredient.id]?.dispose();
      ingredientControllers.remove(ingredient.id);
      current.removeAt(index);
    } else {
      ingredientControllers[ingredient.id ?? ''] = TextEditingController();
      current.add(
        RecipeIngredient(
          id: ingredient.id,
          name: ingredient.name,
          unit: ingredient.defaultUnit,
          amount: 0,
          caloriesPer100g: ingredient.caloriesPer100g,
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

  // ─── MEDIA ───────────────────────────────────────────────────────────────

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
      if (!await _validateMedia(file, type)) return;

      List<RecipeMedia> updated = List.from(state.mediaList);
      if (type == MediaType.video) {
        updated.removeWhere((e) => e.type == MediaType.video);
        updated.insert(0, RecipeMedia(file: file, type: type));
      } else {
        updated.add(RecipeMedia(file: file, type: type));
      }
      emit(state.copyWith(mediaList: updated));
    } catch (e) {
      debugPrint('pickMedia error: $e');
    }
  }

  Future<bool> _validateMedia(XFile file, MediaType type) async {
    final sizeMb = File(file.path).lengthSync() / (1024 * 1024);
    if (type == MediaType.image && sizeMb > MediaRules.maxImageSizeMb) {
      emitFeedback(const ErrorFeedback('Görsel boyutu çok büyük (max 5 MB).'));
      return false;
    }
    if (type == MediaType.video) {
      if (sizeMb > MediaRules.maxVideoSizeMb) {
        emitFeedback(
          const ErrorFeedback('Video boyutu çok büyük (max 50 MB).'),
        );
        return false;
      }
      final duration = await _getVideoDuration(file.path);
      if (duration > MediaRules.maxVideoDuration) {
        emitFeedback(const ErrorFeedback('Video süresi çok uzun.'));
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

  // ─── OTHERS ─────────────────────────────────────────────────────────────────

  void toggleCategory(String id) {
    final categories = List<String>.from(state.recipe.categories ?? []);
    categories.contains(id) ? categories.remove(id) : categories.add(id);
    emit(state.copyWith(recipe: state.recipe.copyWith(categories: categories)));
  }

  void updateDifficulty(String v) {
    emit(state.copyWith(recipe: state.recipe.copyWith(difficulty: v)));
  }

  void clearForm() {
    titleController.clear();
    aboutController.clear();
    servingController.clear();
    durationController.clear();
    directionsController.clear();
    for (final c in ingredientControllers.values) c.clear();
    ingredientControllers.clear();
    emit(
      CreateRecipeState(
        isLoading: false,
        recipe: RecipeModel(),
        mediaList: [],
        isDraftChecked: false,
        hasDraftToShow: false,
      ),
    );
  }

  void _fillFormFromRecipe(RecipeModel recipe) {
    titleController.text = recipe.title ?? '';
    aboutController.text = recipe.about ?? '';
    servingController.text = (recipe.serving ?? '').toString();
    durationController.text = (recipe.duration ?? '').toString();
    directionsController.text = (recipe.steps ?? []).join('\n');

    for (final ingredient in recipe.ingredients ?? []) {
      if (ingredient.id == null) continue;
      final amount = (ingredient.amount ?? 0) == 0
          ? ''
          : ingredient.amount.toString();
      if (ingredientControllers.containsKey(ingredient.id)) {
        ingredientControllers[ingredient.id!]!.text = amount;
      } else {
        ingredientControllers[ingredient.id!] = TextEditingController(
          text: amount,
        );
      }
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    aboutController.dispose();
    servingController.dispose();
    durationController.dispose();
    directionsController.dispose();
    for (final c in ingredientControllers.values) c.dispose();
    return super.close();
  }
}
