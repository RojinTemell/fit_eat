import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),

            Text('FITEAT', style: Theme.of(context).textTheme.displayMedium),
            Text(
              'SIGN UP FREE',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: 20),
            TextInputWidget(
              hintText: 'Email',
              controller: TextEditingController(),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextInputWidget(
              hintText: 'Password',
              controller: TextEditingController(),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),

            BaseButton(
              title: 'Login',
              baseButtonType: BaseButtonType.filledDark,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),
            SizedBox(height: 80),

            BaseButton(
              title: 'Continue with Apple',
              baseButtonType: BaseButtonType.filledGrey,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),
            SizedBox(height: 20),

            BaseButton(
              title: 'Continue with Google',
              baseButtonType: BaseButtonType.filledGrey,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),
            SizedBox(height: 20),
            BaseButton(
              title: 'Continue with Facebook',
              baseButtonType: BaseButtonType.filledGrey,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account ',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                GestureDetector(
                  onTap: () => context.pushNamed('login'),
                  child: Text(
                    'Login ',
                    style: Theme.of(context).textTheme.labelStrong.copyWith(
                      color: Constant.errorText(context),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
