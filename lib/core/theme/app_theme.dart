import 'package:fit_eat/core/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'Open Sans',
      textTheme: AppTextTheme.lightTextTheme,
      brightness: Brightness.light,

      // Brightness.light,
      scaffoldBackgroundColor: Color(0xFFEDEEF1),
      // inputDecorationTheme: AppTextFormFieldTheme.inputDecorationTheme(context),
      // bottomSheetTheme: AppBottomSheetTheme.lightBottomSheetTheme,
      // checkboxTheme: AppCheckboxTheme.checkboxTheme(context),
      // radioTheme: AppRadioTheme.radioTheme(context),
      useMaterial3: false,
    );
  }

  // Function to build dark theme with context
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'Open Sans',
      textTheme: AppTextTheme.darkTextTheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xFF1B1D22),
      // inputDecorationTheme: AppTextFormFieldTheme.inputDecorationTheme(context),
      // bottomSheetTheme: AppBottomSheetTheme.darkBottomSheetTheme,
      // checkboxTheme: AppCheckboxTheme.checkboxTheme(context),
      // radioTheme: AppRadioTheme.radioTheme(context),
      useMaterial3: false,
    );
  }
}
