import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/list_item_selection.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:fit_eat/features/create_recipe_page/intites/selected_categories_title.dart';
import 'package:fit_eat/features/create_recipe_page/widget/categories_bottomsheet.dart';
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
import '../../ingredient/entities/recipe_ingredient.dart';
import '../intites/difficulty_list.dart';
import '../mixin/create_recipe_mixin.dart';
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
              viewModel.createRecipe();

              // context.pushNamed('addListingsSettingsPage');
            },
            // suffixIcon: PhosphorIcon(
            //   PhosphorIcons.arrowCircleRight(PhosphorIconsStyle.bold),
            //   size: 18,
            //   color: Constant.iconWhite(context),
            // ),
          ),
         
          body: SingleChildScrollView(
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
                            style: Theme.of(context).textTheme.labelBaseStrong,
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
                                    child: Image.file(
                                      File(state.mediaList[index].file.path),
                                      height: context.dynamicHeight(0.1),
                                      width: context.dynamicWidth(0.24),
                                      fit: BoxFit.cover,
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
                    child: Row(
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
                              style: Theme.of(context).textTheme.labelBaseStrong
                                  .copyWith(color: Constant.errorIcon(context)),
                            ),
                          ],
                        ),
                        Row(
                          children: List.generate(
                            RecipeDifficulty.values.length,
                            (index) {
                              var difficulty = RecipeDifficulty.values[index];
                              return GestureDetector(
                                onTap: () => viewModel.updateDifficulty(
                                  difficulty.title,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
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
                  ),
                  TextInputWidget(
                    isRequired: true,
                    title: 'Title',
                    controller: titleController,
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: context.symmetricPadding(8, 0),
                    child: TextInputWidget(
                      title: 'Detail',
                      controller: detailController,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  TextInputWidget(
                    isRequired: true,
                    title: 'Directions',
                    hintText: '1- first step \n2-second step',
                    height: context.dynamicHeight(0.18),
                    minLines: 6,
                    maxLines: 8,
                    controller: directionsController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextInputWidget(
                          title: 'Servings',
                          hintText: 'How many people',
                          controller: servingController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextInputWidget(
                          title: 'Minute',
                          hintText: 'How much times',
                          controller: minuteController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: context.symmetricPadding(8, 0),
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
                          listItemSelectionType: ListItemSelectionType.idleCard,
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
                    Column(
                      children: List.generate(ingredients.length, (index) {
                        RecipeIngredient model = ingredients[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: context.dynamicWidth(0.5),
                              child: TextInputWidget(
                                isEnabled: false,

                                controller: TextEditingController(
                                  text: model.name,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(
                              width: context.dynamicWidth(0.25),
                              child: TextInputWidget(
                                hintText: '1/2 Adet',
                                controller: TextEditingController(),
                                onChanged: (value) {
                                  viewModel.updateIngredientQuantity(
                                    ingredientId: model.ingredientId,
                                    quantity: value,
                                  );
                                },
                                keyboardType: TextInputType.text,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                viewModel.removeIngredient(model.ingredientId);
                              },
                              child: Container(
                                height: context.dynamicHeight(0.056),
                                width: context.dynamicWidth(0.1),

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Constant.borderLight(context),
                                  ),
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
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
