import 'package:fit_eat/features/home_page/state/category_state.dart';
import 'package:fit_eat/features/home_page/viewmodel/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/entities/category/category_model.dart';
import '../state/create_recipe_state.dart';
import '../viewmodel/create_recipe_viewmodel.dart';
import 'base_filtre_item.dart';

class CategoriesBottomsheet extends StatelessWidget {
  const CategoriesBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    CreateRecipeViewModel viewModel = context.read<CreateRecipeViewModel>();
    return BlocBuilder<CategoryViewModel, CategoryState>(
      builder: (context, catState) {
        return BlocBuilder<CreateRecipeViewModel, CreateRecipeState>(
          builder: (context, state) {
            final selectedCategories = state.recipe.categories ?? [];
            return SingleChildScrollView(
              child: Column(
                children: List.generate(catState.categoryList.length, (index) {
                  Category category = catState.categoryList[index];
                  bool isChecked = selectedCategories.contains(category.id);

                  return BaseFitreItem(
                    isChecked: isChecked,
                    onChanged: () {
                      viewModel.toggleCategory(category.id);
                    },
                    title: category.title,
                    image: category.imageUrl,
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }
}
