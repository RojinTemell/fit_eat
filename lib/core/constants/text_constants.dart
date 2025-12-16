import 'package:flutter/material.dart';

class Constant {
  static const double defaultFontSize = 16.0;
  static const FontWeight defaultFontWeight = FontWeight.normal;
  static const Color defaultColor = Colors.black;
  static const TextDecoration defaultTextDecoration = TextDecoration.none;

  static TextStyle textStyle({
    double fontSize = defaultFontSize,
    FontWeight fontWeight = defaultFontWeight,
    Color color = defaultColor,
    TextDecoration textDecoration = defaultTextDecoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: textDecoration,
    );
  }

  static Color bgPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF6F7F9)
        : Color(0xFF1B1D22);
  }

  static Color bgBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEDEEF1)
        : Color(0xFF1B1D22);
  }

  //  static Color bgOverlayAlpha(BuildContext context) {
  //     return Theme.of(context).brightness == Brightness.light
  //         ? Color(0xFFFFFFFF)
  //         : Color(0xFF000000);
  //   }
  static Color bgSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF000000);
  }

  //fill
  static Color fillDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFFF6F7F9);
  }

  static Color fillMidDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFD7DAE0)
        : Color(0xFF24262D);
  }

  static Color fillBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEDEEF1)
        : Color(0xFF1B1D22);
  }

  static Color fillLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF6F7F9)
        : Color(0xFF24262D);
  }
  //burası farklı

  static Color fillWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF3D424F);
  }

  static Color fillFixWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFFFFFFFF);
  }

  static Color fillFixBlack(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF000000)
        : Color(0xFF000000);
  }

  static Color fillFixDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFF24262D);
  }

  static Color fillPrimaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFBA361B)
        : Color(0xFFBA361B);
  }

  static Color fillPrimaryBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEE5030)
        : Color(0xFFEE5030);
  }

  static Color fillPrimaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF88871)
        : Color(0xFFF88871);
  }

  static Color fillSecondaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00964E)
        : Color(0xFF00C05F);
  }

  static Color fillSecondaryBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00D66F)
        : Color(0xFF00D66F);
  }

  static Color fillSecondaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF2BFD98)
        : Color(0xFF00964E);
  }

  static Color fillTertiaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFE9BE26)
        : Color(0xFFE9BE26);
  }

  static Color fillTertiaryBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEFD455)
        : Color(0xFFEFD455);
  }

  static Color fillTertiaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFAF4C7)
        : Color(0xFFFAF4C7);
  }

  //text

  static Color textDarker(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D) // Light Mode
        : Color(0xFFD7DAE0); // Dark Mode
  }

  static Color textDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF464C5E) // Light Mode
        : Color(0xFFB3B9C6); // Dark Mode
  }

  static Color textBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF8A94A6) // Light Mode
        : Color(0xFF8A94A6); // Dark Mode
  }

  static Color textLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFD7DAE0) // Light Mode
        : Color(0xFF3D424F); // Dark Mode
  }

  static Color textLighter(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF6F7F9) // Light Mode
        : Color(0xFF24262D); // Dark Mode
  }

  static Color textWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF363A44); // Dark Mode
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEE5030)
        : Color(0xFFEE5030);
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00D66F)
        : Color(0xFF00D66F);
  }

  static Color textSecondaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF70FFBC)
        : Color(0xFF00964E);
  }

  static Color textSecondaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00964E)
        : Color(0xFF00D66F);
  }

  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFE9BE26)
        : Color(0xFFE9BE26);
  }

  static Color textFixDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFF24262D);
  }

  static Color textFixWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFFFFFFFF);
  }

  static Color textDarkFullTransform(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFFFFFFFF);
  }

  //border
  static Color borderDarker(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFFEDEEF1);
  }

  static Color borderDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFB3B9C6)
        : Color(0xFF667085);
  }

  static Color borderLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFD7DAE0)
        : Color(0xFF667085);
  }

  static Color borderLighter(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEDEEF1)
        : Color(0xFF464C5E);
  }

  static Color borderPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEE5030)
        : Color(0xFFEE5030);
  }

  static Color borderTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFE9BE26)
        : Color(0xFFF5E793);
  }

  static Color borderSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00D66F)
        : Color(0xFF00D66F);
  }

  static Color borderWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFFFFFFFF);
  }

  //icon
  static Color iconDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFFEDEEF1);
  }

  static Color iconBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF8A94A6)
        : Color(0xFF8A94A6);
  }

  static Color iconLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFD7DAE0)
        : Color(0xFF3D424F);
  }

  static Color iconWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF24262D);
  }

  static Color iconPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEE5030)
        : Color(0xFFEE5030);
  }

  static Color iconSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00D66F)
        : Color(0xFF00D66F);
  }

  static Color iconSecondaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF00964E)
        : Color(0xFF70FFBC);
  }

  static Color iconSecondaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF70FFBC)
        : Color(0xFF00964E);
  }

  static Color iconTertiaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFCB300)
        : Color(0xFFFCB300);
  }

  static Color iconFix(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF24262D)
        : Color(0xFF24262D);
  }

  static Color iconQuaternary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF458AED)
        : Color(0xFF458AED);
  }

  //error

  static Color errorIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFC21313)
        : Color(0xFFFF6A6A);
  }

  static Color errorText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFE61C1C)
        : Color(0xFFF83B3B);
  }

  static Color errorBorderDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF83B3B)
        : Color(0xFFF83B3B);
  }

  static Color errorBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFA0A0)
        : Color(0xFFFF6A6A);
  }

  static Color errorBgPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFF1F1)
        : Color(0xFF480707);
  }

  static Color errorBgSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFFC7C7)
        : Color(0xFFE61C1C);
  }

  //succes
  static Color successIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF10852B)
        : Color(0xFF0FA931);
  }

  static Color successText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF10852B)
        : Color(0xFF10852B);
  }

  static Color successBorderDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF1ACD42)
        : Color(0xFF43E566);
  }

  static Color successBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF81F49A)
        : Color(0xFF43E566);
  }

  static Color successBgDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF81F49A)
        : Color(0xFF03300F);
  }

  static Color successBgPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEFFEF2)
        : Color(0xFFEFFEF2);
  }

  static Color successBgSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEFFEF2)
        : Color(0xFFEFFEF2);
  }

  // warning
  static Color warningIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFBB8113)
        : Color(0xFFE9BE26);
  }

  static Color warningText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFBB8113)
        : Color(0xFFEFD455);
  }

  static Color warningBorderDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFD9A619)
        : Color(0xFFE9BE26);
  }

  static Color warningBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFEFD455)
        : Color(0xFFF5E793);
  }

  static Color warningBgPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFFCFBEA)
        : Color(0xFF3D200B);
  }

  static Color warningBgSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF5E793)
        : Color(0xFFBB8113);
  }

  // info
  static Color infoIcon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF2657CF)
        : Color(0xFF67AAF3);
  }

  static Color infoText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF2657CF)
        : Color(0xFFF0F6FE);
  }

  static Color infoBorderDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF458AED)
        : Color(0xFF458AED);
  }

  static Color infoBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFF98C8F8)
        : Color(0xFF98C8F8);
  }

  static Color infoBgPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFF0F6FE)
        : Color(0xFF2F6DE1);
  }

  static Color infoBgSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Color(0xFFC2DDFB)
        : Color(0xFF2548A8);
  }
}
