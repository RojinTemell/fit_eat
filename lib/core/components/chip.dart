import 'package:flutter/material.dart';

import '../constants/dynamic_constants.dart';
import '../constants/text_constants.dart';
import '../theme/custom_themes/text_theme.dart';

class BaseChip extends StatelessWidget {
  const BaseChip({
    super.key,
    required this.type,
    this.prefixIcon,
    this.suffixIcon,
    this.title,
    this.size = ChipSize.defaultChip,
    this.icon,
    this.titleStyle,
    this.bgColor,
  });
  final ColorType type;
  final Color? bgColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final String? title;
  final ChipSize size;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.symmetricPadding(4, 6),
      decoration: BoxDecoration(
        color: type == ColorType.auto
            ? null
            : bgColor ?? type.chipBgColor(context),
        borderRadius: BorderRadius.circular(8),
        gradient: type == ColorType.auto
            ? LinearGradient(
                colors: [
                  Color(0xFFFFFB00), // Sarı
                  Color(0xFF7CFFC4), // Açık mavi
                  Color(0xFFCB3DEB), // Mor
                ],
              )
            : null,
        border: type == ColorType.auto
            ? null
            : Border.all(color: type.chipBorderColor(context), width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: prefixIcon != null ? 8 : 0),
            child: prefixIcon ?? SizedBox(),
          ),
          icon ??
              Text(
                title ?? '',
                style:
                    titleStyle ??
                    size
                        .chipSizeExtension(context)
                        .copyWith(color: type.chipTitleColor(context)),
              ),
          Padding(
            padding: EdgeInsets.only(left: suffixIcon != null ? 8 : 0),
            child: suffixIcon ?? SizedBox(),
          ),
        ],
      ),
    );
  }
}

enum ColorType {
  primary,
  secondary,
  info,
  infoSecondary,
  success,
  error,
  warning,
  auto,

  filledGrey,
  filledWhite,
  filledDark,
  filledSuccess,
  filledError,
  filledInfo,
  filledWarning,

  outlinedPrimary,
  outlinedSecondary,
  outlinedInfo,
  outlinedSuccess,
  outlinedError,
  outlinedWarning,
}

enum ChipSize { defaultChip, smallChip, xSmallChip }

extension ChipColor on ColorType {
  Color chipBgColor(BuildContext context) {
    switch (this) {
      // Solid
      case ColorType.primary:
        return Constant.fillWhite(context);
      case ColorType.secondary:
        return Constant.borderLighter(context);
      case ColorType.info:
        return Constant.infoBgPrimary(context);
      case ColorType.infoSecondary:
        return Constant.infoBgPrimary(context);
      case ColorType.success:
        return Constant.successBgPrimary(context);
      case ColorType.error:
        return Constant.errorBgPrimary(context);
      case ColorType.warning:
        return Constant.warningBgPrimary(context);

      case ColorType.filledGrey:
      case ColorType.outlinedError:
        return Constant.fillLight(context);
      case ColorType.filledWhite:
        return Constant.fillWhite(context);
      case ColorType.filledDark:
        return Constant.fillDark(context);
      case ColorType.filledSuccess:
        return Constant.successBgDark(context);
      case ColorType.filledError:
        return Constant.errorBgSecondary(context);
      case ColorType.filledInfo:
        return Constant.infoBgSecondary(context);
      case ColorType.filledWarning:
        return Constant.warningBgSecondary(context);

      // Outlined
      case ColorType.outlinedPrimary:
        return Colors.transparent;
      case ColorType.outlinedSecondary:
        return Colors.transparent;
      case ColorType.outlinedInfo:
        return Colors.transparent;
      case ColorType.outlinedSuccess:
        return Colors.transparent;

      case ColorType.outlinedWarning:
        return Colors.transparent;
      case ColorType.auto:
        throw UnimplementedError();
    }
  }

  Color chipBorderColor(BuildContext context) {
    switch (this) {
      // Solid
      case ColorType.primary:
        return Constant.borderLight(context);
      case ColorType.secondary:
        return Constant.borderDark(context);
      case ColorType.info:
      case ColorType.infoSecondary:
        return Constant.infoBorder(context);

      case ColorType.success:
        return Constant.successBorderDark(context);
      case ColorType.error:
        return Constant.errorBorder(context);
      case ColorType.warning:
        return Constant.warningBorder(context);

      case ColorType.filledGrey:
        return Constant.borderLight(context);
      case ColorType.filledWhite:
        return Constant.borderDark(context);
      case ColorType.filledDark:
        return Constant.fillDark(context);
      case ColorType.filledSuccess:
        return Constant.successBorder(context);
      case ColorType.filledError:
        return Constant.errorBorder(context);
      case ColorType.filledInfo:
        return Constant.infoBorder(context);
      case ColorType.filledWarning:
        return Constant.warningBorder(context);

      // Outlined
      case ColorType.outlinedPrimary:
        return Constant.borderDark(context);
      case ColorType.outlinedSecondary:
        return Constant.borderLight(context);
      case ColorType.outlinedInfo:
        return Constant.infoBorderDark(context);
      case ColorType.outlinedSuccess:
        return Constant.successBorderDark(context);
      case ColorType.outlinedError:
        return Constant.errorBorderDark(context);
      case ColorType.outlinedWarning:
        return Constant.warningBorderDark(context);
      case ColorType.auto:
        throw UnimplementedError();
    }
  }

  Color chipTitleColor(BuildContext context) {
    switch (this) {
      // Solid
      case ColorType.primary:
        return Constant.textDarker(context);
      case ColorType.secondary:
        return Constant.textDarker(context);
      case ColorType.info:
      case ColorType.infoSecondary:
        return Constant.infoText(context);
      case ColorType.success:
        return Constant.successText(context);
      case ColorType.error:
        return Constant.errorText(context);
      case ColorType.warning:
        return Constant.warningText(context);

      case ColorType.filledGrey:
        return Constant.textDarker(context);
      case ColorType.filledWhite:
        return Constant.textDarker(context);
      case ColorType.filledDark:
        return Constant.textLighter(context);
      case ColorType.filledSuccess:
        return Constant.successText(context);
      case ColorType.filledError:
        return Constant.errorText(context);
      case ColorType.filledInfo:
        return Constant.infoText(context);
      case ColorType.filledWarning:
        return Constant.warningText(context);
      // Outlined
      case ColorType.outlinedPrimary:
        return Constant.textDarker(context);
      case ColorType.outlinedSecondary:
        return Constant.textDarker(context);
      case ColorType.outlinedInfo:
        return Constant.infoText(context);
      case ColorType.outlinedSuccess:
        return Constant.successText(context);
      case ColorType.outlinedError:
        return Constant.errorText(context);
      case ColorType.outlinedWarning:
        return Constant.warningText(context);
      case ColorType.auto:
        return Constant.textFixDark(context);
    }
  }
}

extension ChipSizeExtension on ChipSize {
  TextStyle chipSizeExtension(BuildContext context) {
    switch (this) {
      case ChipSize.defaultChip:
        return Theme.of(context).textTheme.labelStrong; // normal boyut
      case ChipSize.smallChip:
        return Theme.of(context).textTheme.labelBaseStrong; // küçük
      case ChipSize.xSmallChip:
        return Theme.of(context).textTheme.labelSmall!; // ekstra küçük
    }
  }
}

// enum ColorType {
//   white,
//   grey,
//   info,
//   success,
//   error,
//   warning,
//   unFocusWhite,
//   unFocusGrey,
//   unFocusInfo,
//   unFocusSuccess,
//   unFocusError,
//   unFocusWarning,
// }

// extension ChipColor on ColorType {
//   Color chipBgColor(BuildContext context) {
//     switch (this) {
//       case ColorType.white:
//         return Constant.borderLight(context);
//       case ColorType.grey:
//         return Constant.borderLighter(context);
//       case ColorType.info:
//         return Constant.infoBorder(context);
//       case ColorType.success:
//         return Constant.successBorder(context);
//       case ColorType.error:
//         return Constant.errorBgSecondary(context);
//       case ColorType.warning:
//         return Constant.warningBgSecondary(context);
//       //
//       case ColorType.unFocusWhite:
//         return Constant.fillWhite(context);
//       case ColorType.unFocusGrey:
//         return Constant.textLighter(context);
//       case ColorType.unFocusInfo:
//         return Constant.infoIcon(context);
//       case ColorType.unFocusSuccess:
//         return Constant.successBgPrimary(context);
//       case ColorType.unFocusError:
//         return Constant.errorBgPrimary(context);
//       case ColorType.unFocusWarning:
//         return Constant.warningBgPrimary(context);
//     }
//   }

//   Color chipBorderColor(BuildContext context) {
//     switch (this) {
//       case ColorType.white:
//         return Constant.textDarker(context);
//       case ColorType.grey:
//         return Constant.borderLight(context);
//       case ColorType.info:
//         return Constant.infoIcon(context);
//       case ColorType.success:
//         return Constant.successBgPrimary(context);
//       case ColorType.error:
//         return Constant.errorBorder(context);
//       case ColorType.warning:
//         return Constant.warningIcon(context);
//       //
//       case ColorType.unFocusWhite:
//         return Constant.borderDark(context);
//       case ColorType.unFocusGrey:
//         return Constant.borderLight(context);
//       case ColorType.unFocusInfo:
//         return Constant.infoIcon(context);
//       case ColorType.unFocusSuccess:
//         return Constant.successBorder(context);
//       case ColorType.unFocusError:
//         return Constant.errorBorder(context);
//       case ColorType.unFocusWarning:
//         return Constant.warningIcon(context);
//     }
//   }

//   Color chipTitleColor(BuildContext context) {
//     switch (this) {
//       case ColorType.white:
//         return Constant.textDarker(context);
//       case ColorType.grey:
//         return Constant.textDarker(context);
//       case ColorType.info:
//         return Constant.infoIcon(context);
//       case ColorType.success:
//         return Constant.successIcon(context);
//       case ColorType.error:
//         return Constant.errorIcon(context);
//       case ColorType.warning:
//         return Constant.warningIcon(context);
//       //
//       case ColorType.unFocusWhite:
//         return Constant.textDarker(context);
//       case ColorType.unFocusGrey:
//         return Constant.textDarker(context);
//       case ColorType.unFocusInfo:
//         return Constant.infoIcon(context);
//       case ColorType.unFocusSuccess:
//         return Constant.successIcon(context);
//       case ColorType.unFocusError:
//         return Constant.errorIcon(context);
//       case ColorType.unFocusWarning:
//         return Constant.warningIcon(context);
//     }
//   }
// }
