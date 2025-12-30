import 'package:fit_eat/core/components/base_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/circle_button.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('productDetail'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Constant.fillWhite(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/snacks.jpeg',
                        height: context.dynamicHeight(0.2),
                        width: context.dynamicWidth(1),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleButton(
                      padding: 4,
                      widget: PhosphorIcon(
                        PhosphorIconsBold.heart,
                        color: Constant.iconDark(context),
                        size: 14,
                      ),
                      callback: () {},
                    ),
                  ),
                  Positioned(
                    // right: 8,
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Constant.fillWhite(context),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIconsBold.clock,
                            color: Constant.iconPrimary(context),
                            size: 16,
                          ),

                          SizedBox(width: 4),
                          Text(
                            '45 min',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(4),
                        ),
                        color: Constant.fillTertiaryBase(context),
                      ),
                      child: Text(
                        'Vegan',
                        style: Theme.of(context).textTheme.labelMediumStrong
                            .copyWith(color: Constant.textWhite(context)),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Healthy Salad Recipes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      'Healthy Salad RecipesHealthy Salad RecipesH ealthy Sal ad RecipesHealthyRecipesHealthy Salad Recipes',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
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
                            style: Theme.of(
                              context,
                            ).textTheme.labelMediumStrong,
                          ),
                        ],
                      ),
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
                          SizedBox(width: 4),
                          Text(
                            '4.3',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          PhosphorIcon(
                            PhosphorIconsFill.dot,
                            color: Constant.iconBase(context),
                            size: 12,
                          ),
                          Text(
                            'Easy',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BaseButton(
                          width: context.dynamicWidth(0.18),
                          prefixIcon: PhosphorIcon(
                            PhosphorIconsBold.fire,
                            color: Constant.iconDark(context),
                            size: 12,
                          ),
                          title: '120 cal',
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
      ),
    );
  }
}
