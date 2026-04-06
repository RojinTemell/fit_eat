import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:fit_eat/features/auth_page/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late AuthViewmodel viewmodel;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    viewmodel = context.read<AuthViewmodel>();
    emailController = TextEditingController(text: "rojintemel02@gmail.com");
    passwordController = TextEditingController(text: "Roj123");
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextInputWidget(
              hintText: 'Password',
              controller: passwordController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),

            BaseButton(
              callback: () {
                if (emailController.text.trim().isNotEmpty &&
                    passwordController.text.trim().isNotEmpty) {
                  viewmodel.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
              title: 'Register',
              baseButtonType: BaseButtonType.filledDark,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),
            SizedBox(height: 80),

            // BaseButton(
            //   title: 'Continue with Apple',
            //   baseButtonType: BaseButtonType.filledGrey,
            //   baseButtonSize: BaseButtonSize.medium,
            //   width: context.dynamicWidth(1),
            // ),
            // SizedBox(height: 20),

            // BaseButton(
            //   title: 'Continue with Google',
            //   baseButtonType: BaseButtonType.filledGrey,
            //   baseButtonSize: BaseButtonSize.medium,
            //   width: context.dynamicWidth(1),
            // ),
            // SizedBox(height: 20),
            // BaseButton(
            //   title: 'Continue with Facebook',
            //   baseButtonType: BaseButtonType.filledGrey,
            //   baseButtonSize: BaseButtonSize.medium,
            //   width: context.dynamicWidth(1),
            // ),
            // SizedBox(height: 20),
            BaseButton(
              callback: () {
                viewmodel.checkAuth();
              },
              title: 'Continue with Anonim',
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
