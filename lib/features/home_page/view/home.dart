import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ProductWidget();
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

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Healthy Salad Recipes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            width: context.dynamicWidth(0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PhosphorIcon(
                  PhosphorIconsBold.heart,
                  color: Constant.iconDark(context),
                  size: 24,
                ),
                PhosphorIcon(
                  PhosphorIconsBold.chatCircle,
                  color: Constant.iconDark(context),
                  size: 24,
                ),
                PhosphorIcon(
                  PhosphorIconsBold.export,
                  color: Constant.iconDark(context),
                  size: 24,
                ),
                PhosphorIcon(
                  PhosphorIconsBold.dotsThree,
                  color: Constant.iconDark(context),
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
