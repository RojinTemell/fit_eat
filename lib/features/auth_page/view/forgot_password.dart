import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/components/appbar.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Update Your Password', actions: []),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spacer(),
            SizedBox(height: 80),
            Text(
              'Update Your Password',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 40),
            // SizedBox(height: 20),
            TextInputWidget(
              title: 'New Password',
              hintText: 'New Password',
              controller: TextEditingController(),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            TextInputWidget(
              title: 'Confirmed Password',
              hintText: 'Confirmed Password',
              controller: TextEditingController(),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 20),
            Container(
              height: context.dynamicHeight(0.13),
              width: context.dynamicWidth(1),
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constant.fillWhite(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your password must include',
                    style: Theme.of(context).textTheme.labelStrong,
                  ),
                  IncludePassword(context),
                  IncludePassword(context),
                  IncludePassword(context),
                ],
              ),
            ),
            SizedBox(height: 30),
            BaseButton(
              title: 'Save',
              baseButtonType: BaseButtonType.filledDark,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }

  Row IncludePassword(BuildContext context) {
    return Row(
      children: [
        PhosphorIcon(
          PhosphorIconsBold.checkCircle,
          color: Constant.iconDark(context),
          size: 14,
        ),
        SizedBox(width: 8),
        Text(
          'Update Your Password',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
