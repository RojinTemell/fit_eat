import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/components/text_input.dart';
import '../../favorite_page/widget/favorite_widget.dart';
import '../widget/product_widget.dart';

class Home extends StatelessWidget {
  Home({super.key});
  List categoryList = ['Dinner', 'Breakfast', 'Salads', 'Lunch', 'Snacks'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // backgroundColor: Constant.fillFixDark(context),
        // bottomBorder: Constant.fillFixDark(context),
        isVisibleWidth: false,
        centerWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextInputWidget(
            prefixIcon: PhosphorIcon(
              PhosphorIconsBold.magnifyingGlass,
              size: 24,
              color: Constant.iconDark(context),
            ),
            hintText: "Find the reciepes",
            height: context.dynamicHeight(0.047),
            controller: TextEditingController(),
            keyboardType: TextInputType.text,
          ),
        ),
        isVisibleLeading: false,
        actions: [SizedBox()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categoryList.length, (index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Constant.fillWhite(context),
                      ),
                      child: Text(
                        categoryList[index],
                        style: Theme.of(context).textTheme.labelStrong,
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, top: 20),
            //   child: Text(
            //     'Son Gezdiğin Ürünler',
            //     style: Theme.of(context).textTheme.titleMedium,
            //   ),
            // ),
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
                    'Son Gezdiğin Ürünler',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Tümünü Gör',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categoryList.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: FavoriteWidget(),
                    );
                  }),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(8, (index) {
                  return ProductWidget();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
