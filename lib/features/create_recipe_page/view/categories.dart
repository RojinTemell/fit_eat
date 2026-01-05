import 'package:fit_eat/core/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/components/text_input.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../../core/theme/custom_themes/text_theme.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        actions: [],
   
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.symmetricPadding(12, 20),
              child: TextInputWidget(
                onChanged: (value) {},
                height: context.dynamicHeight(0.05),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(9),
                  child: GestureDetector(
                    onTap: () {},
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
              child: Padding(
                padding: context.symmetricPadding(0, 20),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed('categoriesSubListe');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constant.fillWhite(context),
                        ),
                        child: Padding(
                          padding: context.symmetricPadding(20, 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.network(
                                      'https://static.vecteezy.com/system/resources/thumbnails/057/068/323/small/single-fresh-red-strawberry-on-table-green-background-food-fruit-sweet-macro-juicy-plant-image-photo.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: context.symmetricPadding(0, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Food Categories',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelStrong,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PhosphorIcon(
                                        PhosphorIcons.caretRight(),
                                        size: 18,
                                        color: Constant.iconDark(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
