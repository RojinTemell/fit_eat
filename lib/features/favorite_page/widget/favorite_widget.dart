import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/components/base_button.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';

class FavoriteWidget extends StatelessWidget {
  const FavoriteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constant.fillWhite(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/task.jpg',
                    height: context.dynamicHeight(0.2),
                    width: context.dynamicWidth(0.4),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: PhosphorIcon(
                    PhosphorIconsFill.heart,
                    color: Constant.iconPrimary(context),
                    size: 20,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: BaseButton(
                    width: context.dynamicWidth(0.16),
                    title: '120 kcal',
                    baseButtonType: BaseButtonType.auto,
                    baseButtonSize: BaseButtonSize.xsmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Container(
              width: context.dynamicWidth(0.38),

              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Healthy Salad Recipes',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Healthy Salad Recipeslthy Salad Recipes',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            '14 min',
                            style: Theme.of(
                              context,
                            ).textTheme.labelMediumStrong,
                          ),
                          SizedBox(width: 2),
                          PhosphorIcon(
                            PhosphorIconsFill.dot,
                            color: Constant.iconDark(context),
                            size: 12,
                          ),
                          SizedBox(width: 2),
                          Row(
                            children: [
                              PhosphorIcon(
                                PhosphorIconsBold.chatCircle,
                                color: Constant.iconDark(context),
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '12',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // PhosphorIcon(
                              //   PhosphorIconsBold.clockClockwise,
                              //   color: Constant.iconDark(context),
                              //   size: 18,
                              // ),
                              // SizedBox(width: 4),
                              // Text(
                              //   'Easy',
                              //   style: Theme.of(context).textTheme.labelLarge,
                              // ),
                            ],
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 4,
                          //     horizontal: 6,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(4),
                          //     color: Constant.fillSecondaryBase(context),
                          //   ),
                          //   child: Text(
                          //     '150 kcal',
                          //     style: Theme.of(
                          //       context,
                          //     ).textTheme.labelMediumStrong,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
