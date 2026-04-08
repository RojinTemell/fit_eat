import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:fit_eat/features/auth_page/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/feedback/feedback_listener.dart';
import '../model/app_user.dart';
import '../viewmodel/auth_viewmodel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  Widget build(BuildContext context) {
    return BlocListener<AuthViewmodel, AuthState>(
      // listenWhen: (_, current) => current.feedback != null,
      listener: (context, state) {
        if (state.feedback != null) {
          FeedbackHandler.handle(context, state.feedback!);
          context.read<AuthViewmodel>().clearFeedback();
        }
        if (state.status == AuthStatus.authenticated) {
          context.goNamed('home');
        }
      },
      child: BlocBuilder<AuthViewmodel, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80),

                  Text(
                    'FITEAT',
                    style: Theme.of(context).textTheme.displayMedium,
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
                    callback: () async {
                      if (emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        print(
                          "bastın ${emailController.text} ${passwordController.text} ",
                        );
                        await viewmodel.signIn(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        context.pushNamed('home');
                      }
                    },
                    title: 'Login',
                    baseButtonType: BaseButtonType.filledDark,
                    baseButtonSize: BaseButtonSize.medium,
                    width: context.dynamicWidth(1),
                  ),
                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.pushNamed('forgotPassword'),
                      child: Text(
                        'Forget your password',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: state.status != AuthStatus.anonymous ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: state.status == AuthStatus.anonymous,
                      child: BaseButton(
                        callback: () async {
                          await viewmodel.checkAuth();
                          context.goNamed('home');
                        },
                        title: 'Continue with Anonymous',
                        baseButtonType: BaseButtonType.filledGrey,
                        baseButtonSize: BaseButtonSize.medium,
                        width: context.dynamicWidth(1),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  BaseButton(
                    title: 'Continue with Google',
                    baseButtonType: BaseButtonType.filledGrey,
                    baseButtonSize: BaseButtonSize.medium,
                    width: context.dynamicWidth(1),
                    callback: () {
                      viewmodel.signInWithGoogle();
                    },
                  ),
                  SizedBox(height: 20),

                  // BaseButton(
                  //   title: 'Continue with Facebook',
                  //   baseButtonType: BaseButtonType.filledGrey,
                  //   baseButtonSize: BaseButtonSize.medium,
                  //   width: context.dynamicWidth(1),
                  // ),
                  // SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to FITEAT',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      GestureDetector(
                        onTap: () => context.pushNamed('signUp'),
                        child: Text(
                          ' Sign up for free',
                          style: Theme.of(context).textTheme.labelStrong
                              .copyWith(color: Constant.errorText(context)),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
