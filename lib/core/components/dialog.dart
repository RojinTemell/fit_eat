import 'dart:async';

import 'package:fit_eat/core/components/base_button.dart';
import 'package:fit_eat/core/components/circle_button.dart';
import 'package:fit_eat/core/constants/dynamic_constants.dart';
import 'package:fit_eat/core/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum AlertType {
  success,
  error,
  warning,
  info,
  question;

  Color backgroundColors(BuildContext context) {
    return switch (this) {
      AlertType.success => Constant.successBgPrimary(context),
      AlertType.error => Constant.errorBgPrimary(context),
      AlertType.warning => Constant.warningBgPrimary(context),
      AlertType.info => Constant.bgBase(context),
      AlertType.question => Constant.bgBase(context),
    };
  }

  Color textColors(BuildContext context) {
    return switch (this) {
      AlertType.success => Constant.successBgPrimary(context),
      AlertType.error => Constant.errorBgPrimary(context),
      AlertType.warning => Constant.warningBgPrimary(context),
      AlertType.info => Constant.bgBase(context),
      AlertType.question => Constant.bgBase(context),
    };
  }

  // IconData get icon => switch (this) {
  //   AlertType.success => Icons.check_circle_outline,
  //   AlertType.error => Icons.error_outline,
  //   AlertType.warning => Icons.warning_amber_rounded,
  //   AlertType.info => Icons.warning_amber_rounded,
  //   AlertType.question => Icons.warning_amber_rounded,
  // };
  String get icon => switch (this) {
    AlertType.success => "success",
    AlertType.error => "error",
    AlertType.warning => "warning",
    AlertType.info => "info",
    AlertType.question => "question",
  };

  BaseButtonType get primaryButton => switch (this) {
    AlertType.success => BaseButtonType.filledGreen,
    AlertType.error => BaseButtonType.filledRed,
    AlertType.warning => BaseButtonType.filledTertiary,
    AlertType.info => BaseButtonType.filledBlue,
    AlertType.question => BaseButtonType.filledGrey,
  };
  BaseButtonType get secondaryButton => switch (this) {
    AlertType.success => BaseButtonType.outlinedGreen,
    AlertType.error => BaseButtonType.outlinedRed,
    AlertType.warning => BaseButtonType.outlinedTertiary,
    AlertType.info => BaseButtonType.outlinedBlue,
    AlertType.question => BaseButtonType.outlinedGrey,
  };
}

class AppPopup {
  static Future<T?> show<T>({
    required BuildContext context,
    required AlertType type,
    required String title,
    required String message,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54, // Arka plan karartma
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: context.dynamicWidth(1),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: type.backgroundColors(context).withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: type.backgroundColors(context).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 8,
                    child: CircleButton(
                      padding: 6,
                      backgroundColor: Constant.iconBase(context),
                      borderColor: Constant.iconBase(context),
                      widget: PhosphorIcon(
                        PhosphorIconsBold.x,
                        size: 12,
                        color: Constant.textFixWhite(context),
                      ),
                      callback: () {},
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min, // İçerik kadar yer kapla
                    children: [
                      Lottie.asset(
                        'assets/json/${type.icon}.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 50),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Constant.textBase(context),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BaseButton(
                              title: "Cancel",
                              callback: () {
                                Navigator.pop(context, true as T);
                              },
                              // width: context.dynamicWidth(0.35),
                              baseButtonType: type.secondaryButton,
                              baseButtonSize: BaseButtonSize.medium,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: BaseButton(
                              title: "Allow",
                              callback: () {
                                Navigator.pop(context, true as T);
                              },
                              // width: context.dynamicWidth(0.35),
                              baseButtonType: type.primaryButton,
                              baseButtonSize: BaseButtonSize.medium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // Opsiyonel: Giriş animasyonu (Aşağıdan yukarı veya ölçeklenme)
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }
}

// class BaseDialog extends StatelessWidget {
//   const BaseDialog({
//     Key? key,
//     this.body,
//     required this.messageTitle,
//     this.messageBody,
//     required this.dialogType,
//     this.iconData,
//     this.isActionsButton,
//     this.closeIcon,
//   }) : super(key: key);
//   final Widget? body;
//   final String messageTitle;
//   final String? messageBody;

//   final DialogType dialogType;
//   final IconData? iconData;
//   final bool? closeIcon;
//   final Widget? isActionsButton;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         margin: context.symmetricPadding(0, 20),
//         decoration: BoxDecoration(
//           color: dialogType.bgColor(context),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(width: 2, color: dialogType.borderColor(context)),
//         ),
//         padding: context.symmetricPadding(20, 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 9,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ignore: unrelated_type_equality_checks
//                           // İkon ve boşluk kontrolü
//                           if (iconData != null) ...[
//                             PhosphorIcon(
//                               iconData!,
//                               size: 24,
//                               color: dialogType.titleColor(context),
//                             ),
//                             const SizedBox(width: 8),
//                           ],
//                           // if (!iconData.isNull)
//                           //   PhosphorIcon(
//                           //     iconData!,
//                           //     size: 24,
//                           //     color: dialogType.titleColor(context),
//                           //   ),
//                           // // ignore: unrelated_type_equality_checks
//                           // if (!iconData.isNull) const SizedBox(width: 8),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 Text(
//                                   messageTitle,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 14,
//                                     color: dialogType.titleColor(context),
//                                   ),
//                                 ),
//                                 body ?? SizedBox(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (messageBody != null)
//                         Text(
//                           messageBody ?? '',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14,
//                             color: Constant.textDarker(context),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 if (closeIcon ?? false)
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: PhosphorIcon(
//                         PhosphorIcons.x(PhosphorIconsStyle.bold),
//                         size: 14,
//                         color: dialogType.titleColor(context),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             // ignore: unrelated_type_equality_checks
//             if (isActionsButton != true)
//               Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   isActionsButton ?? SizedBox(),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// enum DialogType { white, grey, info, success, error, warning }

// extension DialogColor on DialogType {
//   Color bgColor(BuildContext context) {
//     switch (this) {
//       case DialogType.white:
//         return Constant.fillWhite(context);
//       case DialogType.grey:
//         return Constant.textLighter(context);
//       case DialogType.info:
//         return Constant.infoBgPrimary(context);
//       case DialogType.success:
//         return Constant.successBgPrimary(context);
//       case DialogType.error:
//         return Constant.errorBgPrimary(context);
//       case DialogType.warning:
//         return Constant.warningBgPrimary(context);
//     }
//   }

//   Color borderColor(BuildContext context) {
//     switch (this) {
//       case DialogType.white:
//         return Constant.borderLight(context);
//       case DialogType.grey:
//         return Constant.borderLight(context);
//       case DialogType.info:
//         return Constant.infoBorderDark(context);
//       case DialogType.success:
//         return Constant.successBorder(context);
//       case DialogType.error:
//         return Constant.errorBorder(context);
//       case DialogType.warning:
//         return Constant.warningBgPrimary(context);
//     }
//   }

//   Color titleColor(BuildContext context) {
//     switch (this) {
//       case DialogType.white:
//         return Constant.textDarker(context);
//       case DialogType.grey:
//         return Constant.textDarker(context);
//       case DialogType.info:
//         return Constant.infoIcon(context);
//       case DialogType.success:
//         return Constant.successIcon(context);
//       case DialogType.error:
//         return Constant.errorBgPrimary(context);
//       case DialogType.warning:
//         return Constant.warningIcon(context);
//     }
//   }
// }
