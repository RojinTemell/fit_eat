import 'package:fit_eat/core/components/base_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.fillWhite(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/task.jpg',
                    height: context.dynamicHeight(0.3),
                    width: context.dynamicWidth(1),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 8,
                  // left: 0,
                  top: 8,
                  child: PhosphorIcon(
                    PhosphorIconsBold.heart,
                    color: Constant.iconWhite(context),
                    size: 20,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                      ),
                      color: Constant.fillTertiaryBase(context),
                    ),
                    child: Text(
                      'Vegan',
                      style: Theme.of(context).textTheme.labelStrong.copyWith(
                        color: Constant.textWhite(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Healthy Salad Recipes',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              PhosphorIcon(
                                PhosphorIconsBold.clock,
                                color: Constant.iconDark(context),
                                size: 18,
                              ),

                              SizedBox(width: 4),
                              Text(
                                '45 min',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Healthy Salad RecipesHealthy Salad RecipesH ealthy Sal ad RecipesHealthyRecipesHealthy Salad Recipes',
                    style: Theme.of(context).textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Constant.fillBase(context),
                              backgroundImage: NetworkImage(
                                'https://cdn.bynogame.com/shop/shop-default-square-1642511991533.jpeg',
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Anonim Hesap',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              PhosphorIcon(
                                PhosphorIconsFill.star,
                                color: Constant.iconTertiaryLight(context),
                                size: 12,
                              ),
                              PhosphorIcon(
                                PhosphorIconsFill.star,
                                color: Constant.iconTertiaryLight(context),
                                size: 12,
                              ),
                              PhosphorIcon(
                                PhosphorIconsFill.star,
                                color: Constant.iconTertiaryLight(context),
                                size: 12,
                              ),
                              PhosphorIcon(
                                PhosphorIconsFill.star,
                                color: Constant.iconTertiaryLight(context),
                                size: 12,
                              ),
                              PhosphorIcon(
                                PhosphorIconsFill.star,
                                color: Constant.iconTertiaryLight(context),
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '4.3',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BaseButton(
                        prefixIcon: PhosphorIcon(
                          PhosphorIconsBold.spinner,
                          color: Constant.iconDark(context),
                          size: 12,
                        ),
                        title: '120 kcal',
                        baseButtonType: BaseButtonType.auto,
                        baseButtonSize: BaseButtonSize.xsmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
