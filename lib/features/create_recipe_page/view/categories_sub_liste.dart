import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/text_input.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../ingredient/model/ingredient_model.dart';
import '../../ingredient/state/ingredient_state.dart';
import '../../ingredient/viewmodel/ingredient_viewmodel.dart';
import '../state/create_recipe_state.dart';
import '../viewmodel/create_recipe_viewmodel.dart';
import '../widget/base_filtre_item.dart';

class CategoriesSubListe extends StatefulWidget {
  const CategoriesSubListe({super.key});

  @override
  State<CategoriesSubListe> createState() => _CategoriesSubListeState();
}

class _CategoriesSubListeState extends State<CategoriesSubListe> {
  late IngredientViewmodel viewmodel;
  late CreateRecipeViewModel createRecipeViewModel;
  @override
  void initState() {
    viewmodel = context.read<IngredientViewmodel>();
    createRecipeViewModel = context.read<CreateRecipeViewModel>();
    viewmodel.fetchIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IngredientViewmodel, IngredientState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: context.symmetricPadding(12, 20),
                  child: TextInputWidget(
                    onChanged: (value) {
                      // newContext
                      //     .read<SteamListingsViewmodel>()
                      //     .adjustVariationsSearchList(value: value);
                    },
                    height: context.dynamicHeight(0.05),
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(9),
                      child: GestureDetector(
                        onTap: () {
                          // _searchController.clear();
                          // newContext
                          //     .read<SteamListingsViewmodel>()
                          //     .adjustVariationsSearchList(value: '');
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
                    controller: TextEditingController(),
                    hintText: 'Tür ara, AK47, Bayonet...',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CreateRecipeViewModel, CreateRecipeState>(
                    builder: (context, createRecipeState) {
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
