import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/components/appbar.dart';
import '../../../core/components/base_button.dart';
import '../../../core/constants/dynamic_constants.dart';
import '../../../core/constants/text_constants.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode>
    with WidgetsBindingObserver {
  late TextEditingController _pinController;
  late FocusNode _focusNode;
  bool? isValidate;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _pinController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 52,
      textStyle: TextStyle(
        fontSize: 28,
        color: isValidate == null
            ? Constant.textDark(context)
            : isValidate == true
            ? Constant.successText(context)
            : Constant.errorText(context),
        fontWeight: FontWeight.w800,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isValidate == null
              ? Constant.borderLight(context)
              : isValidate == true
              ? Constant.successIcon(context)
              : Constant.errorIcon(context),
        ),
        borderRadius: BorderRadius.circular(16),
        color: Constant.fillWhite(context),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Constant.borderLight(context)),
      borderRadius: BorderRadius.circular(16),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Constant.fillWhite(context),
      ),
    );
    return Scaffold(
      appBar: CustomAppBar(title: 'Enter your verification Code', actions: []),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Enter your verification Code',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Text(
                  'We sent a verification code ',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'rojintemel@gmail.com',
                  style: Theme.of(context).textTheme.labelStrong,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Pinput(
                  controller: _pinController,
                  focusNode: _focusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  length: 6,
                  onCompleted: (value) async {},
                ),
              ),
            ),
            Text(
              'Didnt recieve code ?',
              style: Theme.of(context).textTheme.labelStrong,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'RESEND CODE',
                style: Theme.of(context).textTheme.labelStrong.copyWith(
                  color: Constant.textSecondaryDark(context),
                ),
              ),
            ),
            SizedBox(height: 40),
            BaseButton(
              callback: () => context.pushNamed('home'),
              title: 'Login',
              baseButtonType: BaseButtonType.filledGreen,
              baseButtonSize: BaseButtonSize.medium,
              width: context.dynamicWidth(1),
            ),
          ],
        ),
      ),
    );
  }
}
