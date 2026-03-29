import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/base_button.dart';
import '../../../core/components/text_input.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';
import '../../new_ingredient/services/nutrition_service.dart';
import '../mixin/create_new_recipe_mixin.dart';

class CreateNewIngredient extends StatefulWidget {
  const CreateNewIngredient({super.key});

  @override
  State<CreateNewIngredient> createState() => _CreateNewIngredientState();
}

class _CreateNewIngredientState extends State<CreateNewIngredient>
    with CreateNewRecipeMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputWidget(
          isRequired: true,
          title: 'Title',
          controller: titleController,
          keyboardType: TextInputType.text,
          // onChanged: (value) => viewModel.updateTitle(value),
          // validator: (value) => value.validateRequired('Title'),
        ),
        SizedBox(height: 6),
        Column(
          children: [
            Row(
              children: [
                Text(
                  'Unit',
                  style: Theme.of(context).textTheme.labelBaseStrong.copyWith(
                    color: (Constant.textDarker(context)),
                  ),
                ),
                SizedBox(width: 2),
                Text(
                  '*',
                  style: Theme.of(context).textTheme.labelBaseStrong.copyWith(
                    color: Constant.errorIcon(context),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: NutritionService.units.first,
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
              onChanged: (u) => {unitController.text = u.toString()},
            ),
          ],
        ),
        SizedBox(height: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Can you enter 100g informaitons? İt is not necesseray but it helps to decearse time for approvad',
              style: Theme.of(context).textTheme.labelBaseStrong.copyWith(
                color: (Constant.textPrimary(context)),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                // Malzeme adı
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calories',
                        style: Theme.of(context).textTheme.labelBaseStrong
                            .copyWith(color: (Constant.textDarker(context))),
                      ),
                      TextInputWidget(
                        controller: calController,
                        keyboardType: TextInputType.text,
                        hintText: "0",
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carbs',
                        style: Theme.of(context).textTheme.labelBaseStrong
                            .copyWith(color: (Constant.textDarker(context))),
                      ),
                      TextInputWidget(
                        hintText: "0",

                        controller: carbsController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fat',
                        style: Theme.of(context).textTheme.labelBaseStrong
                            .copyWith(color: (Constant.textDarker(context))),
                      ),
                      TextInputWidget(
                        hintText: "0",
                        controller: fatController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protien',
                        style: Theme.of(context).textTheme.labelBaseStrong
                            .copyWith(color: (Constant.textDarker(context))),
                      ),
                      TextInputWidget(
                        hintText: "0",
                        controller: protienController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),

                // Birim
              ],
            ),
            SizedBox(height: 20),
            BaseButton(
              title: "Send",
              callback: () async {
                // await viewModel.suggestIngredient(
                //   title: titleController.text,
                //   defaultUnit: unitController.text,
                //   caloriesPer100g: calController.text,
                //   carbsPer100g: carbsController.text,
                //   proteinPer100g: protienController.text,
                //   fatPer100g: fatController.text,
                // );
                context.pop();
              },
              width: context.dynamicWidth(1),
              baseButtonType: BaseButtonType.filledGreen,
              baseButtonSize: BaseButtonSize.medium,
            ),
          ],
        ),
      ],
    );
  }
}
