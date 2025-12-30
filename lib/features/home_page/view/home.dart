import 'package:fit_eat/core/components/appbar.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/components/text_input.dart';
import '../widget/last_visited_widget.dart';
import '../widget/product_widget.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});
  List categoryList = ['Dinner', 'Breakfast', 'Salads', 'Lunch', 'Snacks'];
  List categoryImageList = ['salad', 'fastfood', 'breakfast', 'snacks'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Constant.fillWhite(context),
      appBar: CustomAppBar(
        // bottomBorder: Constant.fillPrimaryDark(context),
        // backgroundColor: Constant.fillPrimaryDark(context),
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
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Constant.fillBase(context),
                // borderRadius: BorderRadius.only(
                //   bottomRight: Radius.circular(16),
                //   bottomLeft: Radius.circular(16),
                // ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Constant.fillBase(context),
                    backgroundImage: NetworkImage(
                      'https://cdn.bynogame.com/shop/shop-default-square-1642511991533.jpeg',
                    ),
                  ),

                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      // color: Colors.blue,
                      height: context.dynamicHeight(0.07),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Seni yeniden görmek güzel,',
                            style: Theme.of(context).textTheme.labelSmall,
                            // ?.copyWith(
                            //   color: Constant.textFixWhite(context),
                            // ),
                          ),
                          SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Rojin TEMEL👋',
                              style: Theme.of(context).textTheme.titleLarge,
                              // ?.copyWith(
                              //   color: Constant.textFixWhite(context),
                              // ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    'Categories',
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
                  children: List.generate(categoryImageList.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/${categoryImageList[index]}.jpeg',
                          height: context.dynamicHeight(0.12),
                          width: context.dynamicWidth(0.28),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),
                ),
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
                      child: LastVisitedWidget(),
                    );
                  }),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                childAspectRatio: 0.493,
              ),
              itemBuilder: (context, index) {
                return const ProductWidget();
              },
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: List.generate(8, (index) {
            //       return ProductWidget();
            //     }),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
