import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/circle_button.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List imageList = ['salad', 'fastfood', 'breakfast', 'snacks'];

  int currentIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    List categoryList = [
      {
        "title": '5.0',
        "icon": PhosphorIconsFill.star,
        "color": Constant.iconTertiaryLight(context),
      },
      {
        "title": '14 mins',
        "icon": PhosphorIconsFill.clock,
        "color": Constant.iconDark(context),
      },
      {
        "title": '200 cal',
        "icon": PhosphorIconsFill.fire,
        "color": Constant.iconPrimary(context),
      },
      {
        "title": '4 Servings',
        "icon": PhosphorIconsFill.smiley,
        "color": Constant.iconPrimary(context),
      },
    ];
    return Scaffold(
      // backgroundColor: Constant.fillWhite(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: context.dynamicHeight(0.42),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imageList.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            'assets/images/${imageList[index]}.jpeg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageList.length, (index) {
                          final isActive = index == currentIndex;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: CircleButton(
                    padding: 6,
                    widget: PhosphorIcon(
                      PhosphorIconsBold.caretLeft,
                      color: Constant.iconDark(context),
                      size: 18,
                    ),
                    callback: () => context.pop(),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Constant.fillSecondaryBase(context),
                    ),
                    child: Text(
                      'Easy',
                      style: Theme.of(context).textTheme.labelMediumStrong
                          .copyWith(color: Constant.textWhite(context)),
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  right: 16,
                  child: Row(
                    children: [
                      CircleButton(
                        padding: 6,
                        widget: PhosphorIcon(
                          PhosphorIconsBold.shareFat,
                          color: Constant.iconDark(context),
                          size: 18,
                        ),
                        callback: () {},
                      ),

                      SizedBox(width: 12),
                      CircleButton(
                        padding: 6,
                        widget: PhosphorIcon(
                          PhosphorIconsBold.heart,
                          color: Constant.iconDark(context),
                          size: 18,
                        ),
                        callback: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Green minestrone ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    decoration: BoxDecoration(
                      // color: Constant.fillWhite(context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   'By',
                        //   style: Theme.of(context).textTheme.labelMedium
                        //       ?.copyWith(color: Constant.textBase(context)),

                        //   maxLines: 1,
                        // ),
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Constant.fillBase(context),
                          backgroundImage: NetworkImage(
                            'https://cdn.bynogame.com/shop/shop-default-square-1642511991533.jpeg',
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => context.pushNamed("profile"),
                          child: Text(
                            'Rojin Temel',
                            style: Theme.of(context).textTheme.labelMediumStrong
                                .copyWith(decoration: TextDecoration.underline),

                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(categoryList.length, (index) {
                        return Container(
                          padding: EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Constant.fillWhite(context),
                            border: Border.all(
                              color: Constant.borderLighter(context),
                            ),
                          ),
                          child: Row(
                            children: [
                              PhosphorIcon(
                                categoryList[index]['icon'],
                                color: categoryList[index]['color'],
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                categoryList[index]['title'],
                                style: Theme.of(context).textTheme.labelStrong,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('About', style: Theme.of(context).textTheme.bodyStrong),
                  SizedBox(height: 4),

                  Text(
                    'Healthy Salad RecipesHealthy Salad RecipesH ealthy Sal ad RecipesHealthyRecipesHealthy Salad Recipesd RecipesHealth yRecipesHea lthy Salad Recipesd RecipesHeal thyRecipes Healthy Salad Recipesd RecipesHe althyReci pesHealthy Salad Recipes',
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Container(
                    width: context.dynamicWidth(1),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      //  color: Constant.fillWhite(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients',
                          style: Theme.of(context).textTheme.bodyStrong,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• 8 Ounces of Pasta',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          '• 1/2 Pound of Andoulle Sausage',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'How to Cook',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Healthy Salad RecipesHealthy Salad RecipesH ealthy Sal ad RecipesHealthyRecipesHealthy Salad Recipesd RecipesHealth yRecipesHea lthy Salad Recipesd RecipesHeal thyRecipes Healthy Salad Recipesd RecipesHe althyReci pesHealthy Salad Recipes',
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('answerQuestions'),
                    child: Text(
                      'Tümünü Gör',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(imageList.length, (index) {
                  return Container(
                    margin: context.onlyPadding(0, 2, 0, 20),
                    padding: context.symmetricPadding(20, 8),
                    height: context.dynamicHeight(0.2),
                    width: context.dynamicWidth(0.8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constant.borderLight(context)),
                      borderRadius: BorderRadius.circular(8),
                      color: Constant.bgPrimary(context),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => PhosphorIcon(
                                  PhosphorIconsFill.star,
                                  size: 12,
                                  color: Constant.iconTertiaryLight(context),
                                ),
                              ),
                            ),
                            Text(
                              "30 Ekim 2024",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: Constant.textBase(context)),
                            ),
                          ],
                        ),
                        Text(
                          'Fuel your body with this nutrient-dense green masterpiece. Carefully balanced with plant-based proteins and seasonal veggies, it’s designed to keep your energy levels stable while satisfying your',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Constant.textDarker(context)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Anonim",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: Constant.textBase(context)),
                            ),
                            PhosphorIcon(
                              PhosphorIconsFill.thumbsUp,
                              size: 16,
                              color: Constant.iconBase(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
