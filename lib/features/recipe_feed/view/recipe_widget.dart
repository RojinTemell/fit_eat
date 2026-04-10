import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/features/create_recipe_page/model/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/circle_button.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';

class RecipeWidget extends StatelessWidget {
  const RecipeWidget({super.key, required this.model});
  final RecipeModel model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('recipeDetail', extra: model),
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
                      child: CachedNetworkImage(
                        imageUrl: model.media?[0].url ?? "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                            '${model.duration} min',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "${model.title}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      "${model.about}",
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
                            '${model.authorName}',
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
                            '${model.difficulty}',
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
                          title: '${model.calorie} cal',
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
