import 'package:flutter/material.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';
import 'badge.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,

    // required this.icon,
    this.isLoading,
    this.title,
    this.callback,
    this.suffixIcon,
    this.prefixIcon,
    required this.baseButtonType,
    this.badgeText,
    this.badgeType,
    this.width,
    this.height,
    required this.baseButtonSize,
    this.textColor,
    this.isUnderline,
  });
  // final IconData icon;
  final Color? textColor;
  final String? title;
  final VoidCallback? callback;
  final bool? isLoading;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? badgeText;
  final BadgeType? badgeType;
  final double? width;
  final double? height;
  final BaseButtonType baseButtonType;
  final BaseButtonSize baseButtonSize;
  final bool? isUnderline;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: (isLoading == true) ? null : callback,
          child: Container(
            height: height ?? baseButtonSize.height(context),
            width: width ?? baseButtonSize.width(context),
            decoration: BoxDecoration(
              color: baseButtonType == BaseButtonType.auto
                  ? null
                  : baseButtonType.buttonColor(context),
              gradient: baseButtonType == BaseButtonType.auto
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 222, 220, 87),
                        Color.fromARGB(255, 57, 220, 146),
                        Color.fromARGB(255, 188, 24, 225),
                      ],
                    )
                  : null,
              border:
                  baseButtonType == BaseButtonType.auto ||
                      baseButtonType == BaseButtonType.ghost ||
                      baseButtonType == BaseButtonType.text
                  ? null
                  : Border.all(
                      color: baseButtonType.buttonBorderColor(context),
                    ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixIcon ?? SizedBox(),
                if (title != null)
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                    child: Text(
                      title ?? '',
                      style: Theme.of(context).textTheme.labelStrong.copyWith(
                        color: textColor ?? baseButtonType.textColor(context),
                        decoration: (isUnderline ?? false)
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        // (baseButtonType == BaseButtonType.filledDark ||
                        //         baseButtonType ==
                        //             BaseButtonType.filledDarkWithGreen
                        //     ? Constant.textWhite(context)
                        //     : Constant.textFixDark(context)),
                        fontSize: baseButtonSize.textSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                suffixIcon ?? SizedBox(),
              ],
            ),
          ),
        ),
        if (badgeType != null)
          Positioned(
            top: 0,
            right: 0,
            child: BadgeWidget(
              badgeType: badgeType ?? BadgeType.circleErrorLargeBadge,
              text: badgeText ?? '',
            ),
          ),
      ],
    );
  }
}

enum BaseButtonType {
  filledWhite,
  filledDark,
  filledDarkWithGreen,
  filledGreen,
  filledGrey,
  filledRed,
  filledGreyDisabled,
  outlinedDark,
  outlinedGreen,
  outlinedGrey,
  outlinedRed,
  ghost,
  text,
  auto,
}

enum BaseButtonSize { large, medium, base, small, xsmall }

extension SizeButton on BaseButtonSize {
  double height(BuildContext context) {
    switch (this) {
      case BaseButtonSize.large:
        return context.dynamicHeight(0.068);
      case BaseButtonSize.medium:
        return context.dynamicHeight(0.058);
      case BaseButtonSize.base:
        return context.dynamicHeight(0.05);
      case BaseButtonSize.small:
        return context.dynamicHeight(0.042);
      case BaseButtonSize.xsmall:
        return context.dynamicHeight(0.032);
    }
  }

  double width(BuildContext context) {
    switch (this) {
      case BaseButtonSize.large:
        return context.dynamicWidth(0.41);
      case BaseButtonSize.medium:
        return context.dynamicWidth(0.41);
      case BaseButtonSize.base:
        return context.dynamicWidth(0.25);
      case BaseButtonSize.small:
        return context.dynamicWidth(0.23);
      case BaseButtonSize.xsmall:
        return context.dynamicWidth(0.23);
    }
  }

  double get textSize {
    switch (this) {
      case BaseButtonSize.large:
        return 14;
      case BaseButtonSize.medium:
        return 14;
      case BaseButtonSize.base:
        return 12;
      case BaseButtonSize.small:
        return 11;
      case BaseButtonSize.xsmall:
        return 11;
    }
  }
}

extension ButtonColor on BaseButtonType {
  Color buttonColor(BuildContext context) {
    switch (this) {
      case BaseButtonType.filledWhite:
        return Constant.fillWhite(context);
      case BaseButtonType.filledDark:
      case BaseButtonType.filledDarkWithGreen:
        return Constant.fillDark(context);
      case BaseButtonType.filledGreen:
        return Constant.fillSecondaryBase(context);
      case BaseButtonType.filledGrey:
        return Constant.fillLight(context);
      case BaseButtonType.outlinedRed:
      case BaseButtonType.outlinedDark:
      case BaseButtonType.outlinedGreen:
      case BaseButtonType.outlinedGrey:
        return Constant.fillWhite(context);
      case BaseButtonType.filledGreyDisabled:
        return Constant.fillLight(context);
      case BaseButtonType.ghost:
      case BaseButtonType.text:
        return Colors.transparent;
      case BaseButtonType.filledRed:
        return Constant.fillPrimaryBase(context);
      case BaseButtonType.auto:
        return Colors.transparent;
    }
  }

  Color textColor(BuildContext context) {
    switch (this) {
      case BaseButtonType.filledDark:
        return Constant.textLighter(context);
      case BaseButtonType.filledWhite:
        return Constant.textDarker(context);
      case BaseButtonType.filledGreen:
      case BaseButtonType.filledDarkWithGreen:
      case BaseButtonType.auto:
        return Constant.textFixDark(context);

      case BaseButtonType.outlinedRed:
        return Constant.errorText(context);
      case BaseButtonType.outlinedDark:
      case BaseButtonType.outlinedGreen:
      case BaseButtonType.text:
      case BaseButtonType.ghost:
      case BaseButtonType.outlinedGrey:
      case BaseButtonType.filledGrey:
        return Constant.textDarker(context);
      case BaseButtonType.filledGreyDisabled:
        return Constant.textLight(context);
      case BaseButtonType.filledRed:
        return Constant.textWhite(context);
    }
  }

  Color buttonBorderColor(BuildContext context) {
    switch (this) {
      case BaseButtonType.filledDark:
        return Constant.borderDarker(context);
      case BaseButtonType.filledWhite:
        return Constant.borderLight(context);
      case BaseButtonType.filledGreen:
        return Constant.borderSecondary(context);
      case BaseButtonType.filledGrey:
        return Constant.borderLight(context);
      case BaseButtonType.outlinedDark:
        return Constant.borderDarker(context);
      case BaseButtonType.outlinedGreen:
        return Constant.borderSecondary(context);
      case BaseButtonType.outlinedGrey:
        return Constant.borderLight(context);
      case BaseButtonType.filledGreyDisabled:
        return Constant.borderLighter(context);
      case BaseButtonType.ghost:
        return Colors.transparent;
      case BaseButtonType.text:
        return Colors.transparent;
      case BaseButtonType.filledDarkWithGreen:
        return Constant.borderSecondary(context);
      case BaseButtonType.outlinedRed:
      case BaseButtonType.filledRed:
        return Constant.borderPrimary(context);
      case BaseButtonType.auto:
        return Colors.transparent;
    }
  }
}
