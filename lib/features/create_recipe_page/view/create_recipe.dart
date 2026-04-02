import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/list_item_selection.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:fit_eat/core/utils/validator.dart';
import 'package:fit_eat/features/create_recipe_page/intites/selected_categories_title.dart';
import 'package:fit_eat/features/create_recipe_page/widget/categories_bottomsheet.dart';
import 'package:fit_eat/features/create_recipe_page/widget/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/alert_toast.dart';
import '../../../core/components/bottom_bar_container.dart';
import '../../../core/components/chip.dart';
import '../../../core/components/dialog.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/cubits/bottom_sheet.dart';
import '../../../core/feedback/feedback_listener.dart'; // ← yeni
import '../../home_page/state/category_state.dart';
import '../../home_page/viewmodel/category_view_model.dart';
import '../../ingredient/model/recipe_ingredient.dart';
import '../../ingredient/services/nutrition_service.dart';
import '../intites/difficulty_list.dart';
import '../mixin/create_recipe_mixin.dart';
import '../model/recipe_media_model.dart';
import '../state/create_recipe_state.dart';
import '../viewmodel/create_recipe_viewmodel.dart';
import '../widget/show_pick_media_bottomsheet.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe>
    with CreateRecipePageMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 1) Draft bulundu → dialog göster
        BlocListener<CreateRecipeViewModel, CreateRecipeState>(
          listenWhen: (previous, current) =>
              !previous.hasDraftToShow && current.hasDraftToShow,
          listener: (context, state) async {
            viewModel.draftDialogShown();
            await AppPopup.show(
              context: context,
              type: AlertType.question,
              primaryTitle: 'Continue',
              secondaryTitle: 'New Recipe',
              secondaryButtonCallback: () => viewModel.discardDraft(),
              title: 'Yarım Kalan Tarif',
              message:
                  'Daha önceden başladığınız bir tarif taslağı bulundu. Devam etmek ister misiniz?',
            );
          },
        ),

        // 2) Servis sonucu → Snackbar (tek satır, hepsi otomatik)
        BlocListener<CreateRecipeViewModel, CreateRecipeState>(
          listenWhen: (_, current) => current.feedback != null,
          listener: (context, state) {
            FeedbackHandler.handle(context, state.feedback!);
            context.read<CreateRecipeViewModel>().clearFeedback();
          },
        ),
      ],
      child: BlocBuilder<CreateRecipeViewModel, CreateRecipeState>(
        builder: (context, state) {
          final ingredients = state.recipe.ingredients ?? [];
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (state.hasFormData) {
                final shouldSave = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Taslak Kaydedilsin mi?'),
                    content: const Text(
                      'Çıkmadan önce tarifinizi taslak olarak kaydetmek ister misiniz?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Sil ve Çık'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Taslağı Kaydet'),
                      ),
                    ],
                  ),
                );

                if (shouldSave == true) {
                  await viewModel.saveAsDraft();
                  if (context.mounted) Navigator.pop(context);
                } else if (shouldSave == false) {
                  await viewModel.discardDraft();
                  if (context.mounted) Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Create Recipe',
                actions: [],
                isVisibleLeading: false,
              ),
              bottomNavigationBar: BottomActionBar(
                color: Constant.fillBase(context),
                baseButtonType: BaseButtonType.filledGreen,
                title: 'Create Your Recipe',
                callback: () async {
                  if (createRecipeFormKey.currentState!.validate()) {
                    // Media Kontrolü
                    if (state.mediaList.isEmpty) {
                      showAlertToast(
                        context,
                        type: AlertToastType.error,
                        titleWidget: const Text('Lütfen görsel ekleyin'),
                      );
                      return;
                    }

                    // Kategori Kontrolü
                    if ((state.recipe.categories ?? []).isEmpty) {
                      showAlertToast(
                        context,
                        type: AlertToastType.error,
                        titleWidget: const Text('Lütfen kategori seçin'),
                      );
                      return;
                    }

                    // Malzeme Kontrolü
                    if (ingredients.isEmpty) {
                      showAlertToast(
                        context,
                        type: AlertToastType.error,
                        titleWidget: const Text('Malzeme listesi boş olamaz'),
                      );
                      return;
                    }
                    // Zorluluk Kontrolü
                    if (state.recipe.difficulty == "") {
                      showAlertToast(
                        context,
                        type: AlertToastType.error,
                        titleWidget: const Text(
                          'Zorluluk derecesini seçmeniz lazım',
                        ),
                      );
                      return;
                    }
                    final bool? isConfirm = await AppPopup.show(
                      context: context,
                      type: AlertType.info,
                      primaryTitle: 'Publish',
                      secondaryTitle: 'Cancel',
                      title: 'Confirm Recipe',
                      message:
                          'Are you sure you want to create and publish this recipe?',
                    );
                    if (isConfirm == true) {
                      viewModel.createRecipe();
                    }
                  }
                },
              ),
              body: Form(
                key: createRecipeFormKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: context.allPadding(20),
                    child: Column(
                      children: [
                        // ── Media upload alanı ──────────────────────────
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Upload recipe images or video',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelBaseStrong,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '*',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelBaseStrong
                                      .copyWith(
                                        color: Constant.errorIcon(context),
                                      ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: context.symmetricPadding(8, 0),
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<BottomSheetBloc>()
                                      .showBottomSheet(
                                        context: context,
                                        widget: MediaPickerBottomSheet(),
                                      );
                                },
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color: Constant.borderLight(context),
                                    radius: const Radius.circular(8),
                                    dashPattern: const [5, 5],
                                    strokeWidth: 1.2,
                                  ),
                                  child: Container(
                                    width: context.dynamicWidth(1),
                                    height: context.dynamicHeight(0.16),
                                    decoration: BoxDecoration(
                                      color: Constant.fillMidDark(context),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upload images & video',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Constant.textBase(
                                                  context,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        PhosphorIcon(
                                          PhosphorIconsBold.plusCircle,
                                          color: Constant.iconBase(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (state.mediaList.isNotEmpty)
                              Wrap(
                                children: List.generate(
                                  state.mediaList.length,
                                  (index) {
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: context.onlyPadding(
                                            8,
                                            8,
                                            0,
                                            0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child:
                                                state.mediaList[index].type ==
                                                    MediaType.image
                                                ? Image.file(
                                                    File(
                                                      state
                                                          .mediaList[index]
                                                          .file
                                                          .path,
                                                    ),
                                                    height: context
                                                        .dynamicHeight(0.12),
                                                    width: context.dynamicWidth(
                                                      0.24,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                : SingleVideoPlayer(
                                                    file: File(
                                                      state
                                                          .mediaList[index]
                                                          .file
                                                          .path,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => viewModel.removeMedia(
                                              state.mediaList[index],
                                            ),
                                            child: PhosphorIcon(
                                              PhosphorIconsFill.xCircle,
                                              color: Constant.iconTertiaryLight(
                                                context,
                                              ),
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Difficulty ──────────────────────────────────
                        Padding(
                          padding: context.symmetricPadding(16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Choose Type',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelBaseStrong,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '*',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelBaseStrong
                                            .copyWith(
                                              color: Constant.errorIcon(
                                                context,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: List.generate(
                                      RecipeDifficulty.values.length,
                                      (index) {
                                        final difficulty =
                                            RecipeDifficulty.values[index];
                                        return GestureDetector(
                                          onTap: () =>
                                              viewModel.updateDifficulty(
                                                difficulty.title,
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: BaseChip(
                                              type:
                                                  difficulty.title ==
                                                      state.recipe.difficulty
                                                  ? difficulty.selectedType
                                                  : difficulty.type,
                                              title: difficulty.title,
                                              size: ChipSize.smallChip,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ── Form alanları ───────────────────────────────
                        TextInputWidget(
                          isRequired: true,
                          title: 'Title',
                          controller: viewModel.titleController,
                          keyboardType: TextInputType.text,
                          // onChanged: viewModel.updateTitle,
                          validator: (value) => value.validateRequired('Title'),
                        ),
                        Padding(
                          padding: context.symmetricPadding(8, 0),
                          child: TextInputWidget(
                            title: 'Detail',
                            controller: viewModel.aboutController,
                            keyboardType: TextInputType.text,
                            // onChanged: viewModel.updateAbout,
                          ),
                        ),
                        TextInputWidget(
                          isRequired: true,
                          title: 'Directions',
                          hintText: '1- first step \n2-second step',
                          validator: (value) =>
                              value.validateRequired('Directions'),
                          height: context.dynamicHeight(0.18),
                          // onChanged: (value) => viewModel.updateSteps(
                          //   value
                          //       .split('\n')
                          //       .where((e) => e.trim().isNotEmpty)
                          //       .toList(),
                          // ),
                          minLines: 6,
                          maxLines: 8,
                          controller: viewModel.directionsController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                        ),
                        Padding(
                          padding: context.symmetricPadding(16, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextInputWidget(
                                  title: 'Servings',
                                  hintText: 'How many people',
                                  controller: viewModel.servingController,
                                  keyboardType: TextInputType.number,
                                  // onChanged: (value) =>
                                  //     viewModel.updateServing(
                                  //         int.tryParse(value) ?? 1),
                                  validator: (value) =>
                                      value.validateRequired('Servings'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextInputWidget(
                                  title: 'Minute',
                                  hintText: 'How much times',
                                  controller: viewModel.durationController,
                                  keyboardType: TextInputType.number,
                                  // onChanged: (value) =>
                                  //     viewModel.updateDuration(
                                  //         int.tryParse(value) ?? 0),
                                  validator: (value) =>
                                      value.validateRequired('Minute'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Categories ──────────────────────────────────
                        Padding(
                          padding: context.symmetricPadding(16, 0),
                          child: BlocBuilder<CategoryViewModel, CategoryState>(
                            builder: (context, catState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListItemSelection(
                                    title: 'Categories',
                                    callback: () {
                                      context
                                          .read<BottomSheetBloc>()
                                          .showBottomSheet(
                                            context: context,
                                            widget: CategoriesBottomsheet(),
                                          );
                                    },
                                    listItemSelectionType:
                                        ListItemSelectionType.idleCard,
                                    subtitle: selectedCategoriesString(
                                      state.recipe.categories ?? [],
                                      catState.categoryList,
                                    ),
                                  ),
                                  if ((state.recipe.categories ?? []).isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 4,
                                      ),
                                      child: Text(
                                        'En az bir kategori seçmelisiniz *',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: Constant.errorText(
                                                context,
                                              ),
                                            ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),

                        // ── Ingredients ─────────────────────────────────
                        SizedBox(
                          width: context.dynamicWidth(1),
                          child: ListItemSelection(
                            title: 'Choose or write item ',
                            subtitle: "You have to add minimum 1 item ",
                            isTrailingIcon: SizedBox(),
                            trailingText: GestureDetector(
                              onTap: () => context.pushNamed('ingredientsPage'),
                              child: PhosphorIcon(
                                PhosphorIcons.caretCircleRight(),
                                color: Constant.iconFix(context),
                                size: 24,
                              ),
                            ),
                            callback: () =>
                                context.pushNamed('ingredientsPage'),
                            listItemSelectionType:
                                ListItemSelectionType.idleCard,
                          ),
                        ),
                        if (ingredients.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              final model = ingredients[index];
                              final controller =
                                  viewModel.ingredientControllers[model.id];
                              return _IngredientRow(
                                model: model,
                                controller: controller,
                                onAmountChanged: (value) =>
                                    viewModel.updateIngredientAmount(
                                      ingredientId: model.id,
                                      amount: double.tryParse(value) ?? 0,
                                    ),
                                onUnitChanged: (unit) =>
                                    viewModel.updateIngredientUnit(
                                      ingredientId: model.id,
                                      unit: unit,
                                    ),
                                onDelete: () async {
                                  final bool? isShow = await AppPopup.show(
                                    context: context,
                                    type: AlertType.warning,
                                    primaryTitle: 'Delete',
                                    secondaryTitle: 'Cancel',
                                    title: 'Silme',
                                    message:
                                        'Bu içeriği tarifinizden kaldırmak istediğinize emin misiniz?',
                                  );
                                  if (isShow == true) {
                                    viewModel.removeIngredient(model.id);
                                  }
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── _IngredientRow ─────────────────────────────────────────────────────────

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient model;
  final TextEditingController? controller;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onDelete;

  const _IngredientRow({
    required this.model,
    required this.controller,
    required this.onAmountChanged,
    required this.onUnitChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.symmetricPadding(4, 0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextInputWidget(
              isEnabled: false,
              controller: TextEditingController(text: model.name),
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: TextInputWidget(
              hintText: '0',
              controller: controller ?? TextEditingController(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: onAmountChanged,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 4,
            child: DropdownButtonFormField<String>(
              value: NutritionService.units.contains(model.unit)
                  ? model.unit
                  : NutritionService.units.first,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Constant.borderLight(context),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Constant.borderLight(context),
                    width: 1.5,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Constant.borderLight(context)),
                ),
                filled: true,
                fillColor: Constant.fillWhite(context),
              ),
              items: NutritionService.units
                  .map(
                    (u) => DropdownMenuItem(
                      value: u,
                      child: Text(u, style: const TextStyle(fontSize: 12)),
                    ),
                  )
                  .toList(),
              onChanged: (u) => onUnitChanged(u!),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              height: context.dynamicHeight(0.056),
              width: context.dynamicWidth(0.1),
              decoration: BoxDecoration(
                border: Border.all(color: Constant.borderLight(context)),
                borderRadius: BorderRadius.circular(8),
                color: Constant.fillWhite(context),
              ),
              child: PhosphorIcon(
                PhosphorIcons.trash(),
                size: 20,
                color: Constant.iconBase(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
