import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/text_input.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:fit_eat/features/auth_page/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/feedback/feedback_listener.dart';
import '../state/auth_state.dart';

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
    passwordController = TextEditingController(text: "Roj1234");
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
    return BlocListener<AuthViewmodel, AuthState>(
      // listenWhen: (_, current) => current.feedback != null,
      // Navigation BURADA YOK — router redirect AuthAuthenticated geçişini
      // yakalar ve /home'a (veya `from` query'sine) yönlendirir.
      listener: (context, state) {
        if (state.feedback != null) {
          FeedbackHandler.handle(context, state.feedback!);
          context.read<AuthViewmodel>().clearFeedback();
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
                  BaseButton(
                    title: 'Continue with Google',
                    callback: () {
                      viewmodel.signInWithGoogle();
                    },
                    baseButtonType: BaseButtonType.filledGrey,
                    baseButtonSize: BaseButtonSize.medium,
                    width: context.dynamicWidth(1),
                  ),
                  SizedBox(height: 20),

                  // V0.1: AuthAnonymous state'inde misafir butonu gizli —
                  // kullanıcı zaten anon, basmak hiçbir şey yapmaz. Sadece
                  // AuthUnauthenticated state'inde görünür ve aktif olur.
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: state is! AuthAnonymous ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: state is AuthAnonymous,
                      child: BaseButton(
                        callback: () async {
                          await viewmodel.continueAsAnonymous();
                          // Navigation router redirect tarafından handle edilir.
                        },
                        title: 'Continue with Anonymous',
                        baseButtonType: BaseButtonType.filledGrey,
                        baseButtonSize: BaseButtonSize.medium,
                        width: context.dynamicWidth(1),
                      ),
                    ),
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
