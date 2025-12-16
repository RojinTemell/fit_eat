import 'package:flutter/material.dart';

class AppBottomSheetTheme {
  AppBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    // dragHandleColor: Constant.borderLighter,
    modalBackgroundColor: Color(0xFFEDEEF1),
    backgroundColor: Color(0xFFEDEEF1),
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    // dragHandleColor: Constant.borderLighter,
    backgroundColor: Color(0xFF24262D),
    modalBackgroundColor: Color(0xFF24262D),
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
