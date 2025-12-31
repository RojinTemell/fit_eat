import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/components/text_input.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';
import '../../home_page/widget/product_widget.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: context.symmetricPadding(12, 12),
              child: TextInputWidget(
                prefixIcon: PhosphorIcon(
                  PhosphorIconsBold.magnifyingGlass,
                  size: 24,
                  color: Constant.iconBase(context),
                ),
                hintText: "Beğendiklerimde ara ..",
                height: context.dynamicHeight(0.047),
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              child: GridView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
