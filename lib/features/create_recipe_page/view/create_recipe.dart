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
import '../../../core/components/bottom_bar_container.dart';
import '../../../core/components/chip.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/cubits/bottom_sheet.dart';
import '../../home_page/state/category_state.dart';
import '../../home_page/viewmodel/category_view_model.dart';
import '../../new_ingredient/models/recipe_ingredient.dart';
import '../../new_ingredient/services/nutrition_service.dart';
import '../intites/difficulty_list.dart';
import '../mixin/create_recipe_mixin.dart';
import '../model/recipe_media_model.dart';
import '../state/create_recipe_state.dart';
import '../viewmodel/create_recipe_viewmodel.dart';
import '../widget/show_pick_media_bottomsheet.dart';

// ignore: must_be_immutable
class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe>
    with CreateRecipePageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRecipeViewModel, CreateRecipeState>(
      builder: (context, state) {
        final ingredients = state.recipe.ingredients ?? [];
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Create Recipe',
            actions: [],
            isVisibleLeading: false,
          ),
          bottomNavigationBar: BottomActionBar(
            color: Constant.fillBase(context),
            baseButtonType: BaseButtonType.filledGreen,
            title: 'Create Your Recipe',
            callback: () {
              if (createRecipeFormKey.currentState!.validate()) {
                // If the Form says it's valid, but you have logic-based requirements (like media)
                if (state.mediaList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please upload at least one image/video"),
                    ),
                  );
                  return;
                }

                viewModel.createRecipe();
              }

              // context.pushNamed('addListingsSettingsPage');
            },
            // suffixIcon: PhosphorIcon(
            //   PhosphorIcons.arrowCircleRight(PhosphorIconsStyle.bold),
            //   size: 18,
            //   color: Constant.iconWhite(context),
            // ),
          ),

          body: Form(
            key: createRecipeFormKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: context.allPadding(20),
                child: Column(
                  children: [
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
                            SizedBox(width: 2),
                            Text(
                              '*',
                              style: Theme.of(context).textTheme.labelBaseStrong
                                  .copyWith(color: Constant.errorIcon(context)),
                            ),
                          ],
                        ),

                        Padding(
                          padding: context.symmetricPadding(8, 0),
                          child: GestureDetector(
                            onTap: () {
                              context.read<BottomSheetBloc>().showBottomSheet(
                                context: context,
                                widget: MediaPickerBottomSheet(),
                              );
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: Constant.borderLight(context),
                                radius: Radius.circular(8),
                                dashPattern: [5, 5],
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Upload images & video',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Constant.textBase(context),
                                          ),
                                    ),
                                    SizedBox(height: 8),
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
                            children: List.generate(state.mediaList.length, (
                              index,
                            ) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: context.onlyPadding(8, 8, 0, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
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
                                              height: context.dynamicHeight(
                                                0.12,
                                              ),
                                              width: context.dynamicWidth(0.24),
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
                                      onTap: () {
                                        viewModel.removeMedia(
                                          state.mediaList[index],
                                        );
                                      },
                                      child: GestureDetector(
                                        child: PhosphorIcon(
                                          PhosphorIconsFill.xCircle,
                                          color: Constant.iconTertiaryLight(
                                            context,
                                          ),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                      ],
                    ),

                    SizedBox(height: 12),
                    Padding(
                      padding: context.symmetricPadding(16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Choose Type',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelBaseStrong,
                                  ),
                                  SizedBox(width: 2),
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
                              Row(
                                children: List.generate(
                                  RecipeDifficulty.values.length,
                                  (index) {
                                    var difficulty =
                                        RecipeDifficulty.values[index];
                                    return GestureDetector(
                                      onTap: () => viewModel.updateDifficulty(
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
                    TextInputWidget(
                      isRequired: true,
                      title: 'Title',
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => viewModel.updateTitle(value),
                      validator: (value) => value.validateRequired('Title'),
                    ),
                    Padding(
                      padding: context.symmetricPadding(8, 0),
                      child: TextInputWidget(
                        title: 'Detail',
                        controller: detailController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => viewModel.updateAbout(value),
                      ),
                    ),
                    TextInputWidget(
                      isRequired: true,
                      title: 'Directions',
                      hintText: '1- first step \n2-second step',
                      validator: (value) =>
                          value.validateRequired('Directions'),
                      height: context.dynamicHeight(0.18),
                      onChanged: (value) => viewModel.updateSteps(
                        value
                            .split('\n')
                            .where((e) => e.trim().isNotEmpty)
                            .toList(),
                      ),
                      minLines: 6,
                      maxLines: 8,
                      controller: directionsController,
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
                              controller: servingController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => viewModel.updateServing(
                                int.tryParse(value) ?? 1,
                              ),

                              validator: (value) =>
                                  value.validateRequired('Servings'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextInputWidget(
                              title: 'Minute',
                              hintText: 'How much times',
                              controller: minuteController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => viewModel.updateDuration(
                                int.tryParse(value) ?? 0,
                              ),
                              validator: (value) =>
                                  value.validateRequired('Minute'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: context.symmetricPadding(16, 0),
                      child: BlocBuilder<CategoryViewModel, CategoryState>(
                        builder: (context, catState) {
                          return ListItemSelection(
                            title: 'Categories',
                            callback: () {
                              context.read<BottomSheetBloc>().showBottomSheet(
                                context: context,
                                widget: CategoriesBottomsheet(),
                              );
                              // context.pushNamed('categories');
                            },
                            listItemSelectionType:
                                ListItemSelectionType.idleCard,
                            subtitle: selectedCategoriesString(
                              state.recipe.categories ?? [],
                              catState.categoryList,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: context.dynamicWidth(1),
                      child: TextInputWidget(
                        hintText: 'Choose or write item',
                        controller: ingredientSearchController,
                        keyboardType: TextInputType.text,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            context.pushNamed('ingredientsPage');
                          },
                          child: PhosphorIcon(
                            PhosphorIcons.caretCircleDown(),
                            color: Constant.iconFix(context),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    if (state.recipe.ingredients != [])
                      if (ingredients.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            final model = ingredients[index];

                            // Controller map'ten geliyor — rebuild olunca sıfırlanmaz
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
                              onDelete: () =>
                                  viewModel.removeIngredient(model.id),
                            );
                          },
                        ),

                    // Column(
                    //   children: List.generate(ingredients.length, (index) {
                    //     RecipeIngredient model = ingredients[index];
                    //     final controller =
                    //         viewModel.ingredientControllers[model.id];
                    //     return Padding(
                    //       padding: context.symmetricPadding(8, 0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           SizedBox(
                    //             width: context.dynamicWidth(0.5),
                    //             child: TextInputWidget(
                    //               isEnabled: false,

                    //               controller: TextEditingController(
                    //                 text: model.name,
                    //               ),
                    //               keyboardType: TextInputType.text,
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: context.dynamicWidth(0.25),
                    //             child: TextInputWidget(
                    //               hintText: '${model.amount} ${model.unit}',
                    //               controller:
                    //                   controller ?? TextEditingController(),
                    //               onChanged: (value) {
                    //                 viewModel.updateIngredientAmount(
                    //                   ingredientId: model.id,
                    //                   amount: double.tryParse(value) ?? 0,
                    //                 );
                    //               },
                    //               // validator: (value) =>
                    //               //     value.validateRequired('Ingredients'),
                    //               keyboardType: TextInputType.text,
                    //             ),
                    //           ),

                    //           GestureDetector(
                    //             onTap: () {
                    //               viewModel.removeIngredient(model.id);
                    //             },
                    //             child: Container(
                    //               height: context.dynamicHeight(0.056),
                    //               width: context.dynamicWidth(0.1),

                    //               decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   color: Constant.borderLight(context),
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(8),
                    //                 color: Constant.fillWhite(context),
                    //               ),
                    //               child: PhosphorIcon(
                    //                 PhosphorIcons.trash(),
                    //                 size: 20,
                    //                 color: Constant.iconBase(context),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   }),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
          // Malzeme adı (disabled)
          Expanded(
            flex: 3,
            child: TextInputWidget(
              isEnabled: false,
              controller: TextEditingController(text: model.name),
              keyboardType: TextInputType.text,
            ),
          ),

          SizedBox(width: 6),

          // Miktar
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

          SizedBox(width: 6),

          // Birim
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
                    color: Constant.borderLight(
                      context,
                    ), // Buraya istediğin sabit rengi verebilirsin
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
                  borderSide: BorderSide(
                    color: (Constant.borderLight(context)),
                  ),
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
          SizedBox(width: 6),

          // Sil
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
