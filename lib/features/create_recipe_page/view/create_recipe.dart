import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/list_item_selection.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/bottom_bar_container.dart';
import '../../../core/components/chip.dart';
import '../../../core/constants/text_constants.dart';

// ignore: must_be_immutable
class CreateRecipe extends StatelessWidget {
  const CreateRecipe({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                decoration: BoxDecoration(
                  color: Constant.fillWhite(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: context.dynamicHeight(0.2),
                width: context.dynamicWidth(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose Image or Video',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    PhosphorIcon(
                      PhosphorIconsBold.plusCircle,
                      color: Constant.iconDark(context),
                    ),
                  ],
                ),
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
                    Row(
                      children: [
                        BaseChip(
                          type: ColorType.filledWarning,
                          title: 'EASY',
                          size: ChipSize.smallChip,
                        ),
                        SizedBox(width: 8),
                        BaseChip(
                          type: ColorType.filledInfo,
                          title: 'MEDIUM',
                          size: ChipSize.smallChip,
                        ),
                        SizedBox(width: 8),
                        BaseChip(
                          type: ColorType.filledError,
                          title: 'HARD',
                          size: ChipSize.smallChip,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextInputWidget(
                isRequired: true,
                title: 'Title',
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
              ),
              Padding(
                padding: context.symmetricPadding(8, 0),
                child: TextInputWidget(
                  title: 'Detail',
                  controller: TextEditingController(),
                  keyboardType: TextInputType.text,
                ),
              ),
              TextInputWidget(
                isRequired: true,
                title: 'Directions',
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
              ),

              Row(
                children: [
                  Expanded(
                    child: TextInputWidget(
                      title: 'Server',
                      hintText: 'How many people',
                      controller: TextEditingController(),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextInputWidget(
                      title: 'Minute',
                      hintText: 'How much times',
                      controller: TextEditingController(),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  // Text(
                  //   'Server Amount',
                  //   style: Theme.of(context).textTheme.labelBaseStrong,
                  // ),
                ],
              ),
              Padding(
                padding: context.symmetricPadding(8, 0),
                child: ListItemSelection(
                  title: 'Categories',
                  callback: () {
                    context.pushNamed('categories');
                  },
                  listItemSelectionType: ListItemSelectionType.idleCard,
                  subtitle: 'Dinner, healty, salad',
                ),
              ),
              SizedBox(
                width: context.dynamicWidth(1),
                child: TextInputWidget(
                  hintText: 'Choose or write item',
                  controller: TextEditingController(),
                  keyboardType: TextInputType.text,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      context.pushNamed('categories');
                    },
                    child: PhosphorIcon(
                      PhosphorIcons.caretCircleDown(),
                      color: Constant.iconFix(context),
                      size: 24,
                    ),
                  ),
                ),
              ),
              Column(
                children: List.generate(5, (index) {
                  return SizedBox(
                    child: TextInputWidget(
                      // hintText: '1/2 Pound of Andoulle Sausage',
                      controller: TextEditingController(
                        text: '1/2 Pound of Andoulle Sausage',
                      ),
                      keyboardType: TextInputType.text,
                      suffixIcon: PhosphorIcon(
                        PhosphorIcons.xCircle(),
                        color: Constant.fillFixDark(context),
                      ),
                    ),
                  );
                }),
              ),

              // Text(
              //   'Easy',
              //   style: Theme.of(context).textTheme.labelMediumStrong.copyWith(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
