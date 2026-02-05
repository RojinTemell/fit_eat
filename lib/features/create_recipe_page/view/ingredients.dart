import 'package:fit_eat/core/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/base_button.dart';
import '../../../core/components/text_input.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../ingredient/model/ingredient_model.dart';
import '../../ingredient/state/ingredient_state.dart';
import '../../ingredient/viewmodel/ingredient_viewmodel.dart';
import '../state/create_recipe_state.dart';
import '../viewmodel/create_recipe_viewmodel.dart';
import '../widget/base_filtre_item.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  late IngredientViewmodel viewmodel;
  late CreateRecipeViewModel createRecipeViewModel;
  late TextEditingController searchController;
  @override
  void initState() {
    viewmodel = context.read<IngredientViewmodel>();
    searchController = TextEditingController();
    createRecipeViewModel = context.read<CreateRecipeViewModel>();
    viewmodel.fetchIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IngredientViewmodel, IngredientState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(actions: [], title: "Ingredients"),

          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: context.symmetricPadding(12, 20),
                  child: TextInputWidget(
                    onChanged: (value) {
                      viewmodel.searchIngredient(key: value);
                    },
                    height: context.dynamicHeight(0.05),
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(9),
                      child: GestureDetector(
                        onTap: () {
                          viewmodel.clearSearch();
                          searchController.clear();
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Constant.fillLight(context),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              PhosphorIcons.x(PhosphorIconsStyle.bold),
                              size: 12.0,
                              color: Constant.iconDark(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    prefixIcon: PhosphorIcon(
                      PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                      color: Constant.iconDark(context),
                    ),
                    controller: searchController,
                    hintText: 'add ingredients',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CreateRecipeViewModel, CreateRecipeState>(
                    builder: (context, createRecipeState) {
                      if (state.isLoading) {
                        return Text("loading");
                      } else if (state.ingredients.isNotEmpty &&
                          !state.isLoading) {
                        return Padding(
                          padding: context.symmetricPadding(0, 20),
                          child: ListView.builder(
                            itemCount: state.ingredients.length,
                            itemBuilder: (context, index) {
                              IngredientModel item = state.ingredients[index];
                              final isChecked = createRecipeState
                                  .recipe
                                  .ingredients
                                  ?.any((e) => e.ingredientId == item.id);
                              return BaseFitreItem(
                                isChecked: isChecked ?? false,
                                onChanged: () {
                                  createRecipeViewModel.toggleIngredient(item);
                                },
                                title: item.name,
                                image: item.image,
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                          padding: context.onlyPadding(18, 12, 24, 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    'You couldnt find your necessary items,',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    'Add your own ingredient',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              BaseButton(
                                title: "Create",
                                width: context.dynamicWidth(1),
                                baseButtonType: BaseButtonType.filledGreen,
                                baseButtonSize: BaseButtonSize.medium,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     SizedBox(
                              //       width: context.dynamicWidth(0.5),
                              //       child: TextInputWidget(
                              //         isRequired: true,
                              //         hintText: 'write your ing..',
                              //         controller: TextEditingController(),
                              //         keyboardType: TextInputType.text,
                              //       ),
                              //     ),
                              //     BaseButton(
                              //       title: "Save",
                              //       baseButtonType: BaseButtonType.filledGreen,
                              //       baseButtonSize: BaseButtonSize.medium,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
