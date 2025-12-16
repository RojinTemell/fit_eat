import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: const TextStyle().copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    displayMedium: const TextStyle().copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    displaySmall: const TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    headlineLarge: const TextStyle().copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    titleLarge: const TextStyle().copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    titleSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF24262D),
        letterSpacing: 0),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Color(0xFF24262D),
        letterSpacing: 0),

    bodyMedium: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF24262D),
        letterSpacing: 0),

    bodySmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF24262D),
        letterSpacing: 0),

    labelLarge: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF24262D),
        letterSpacing: 0),

    labelMedium: const TextStyle().copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Color(0xFF24262D),
        letterSpacing: 0),

    labelSmall: const TextStyle().copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: Color(0xFF24262D),
        letterSpacing: 0),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: const TextStyle().copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    displayMedium: const TextStyle().copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    displaySmall: const TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    headlineLarge: const TextStyle().copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    titleLarge: const TextStyle().copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    titleSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),

    bodyMedium: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),

    bodySmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),

    labelLarge: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),

    labelMedium: const TextStyle().copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),

    labelSmall: const TextStyle().copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: Color(0xFFB3B9C6),
        letterSpacing: 0),
  );
}

extension BngTextAliases on TextTheme {
  // Body
  TextStyle get bodyStrong => (bodyLarge ?? const TextStyle())
      .copyWith(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get bodyMediumStrong => (bodyMedium ?? const TextStyle())
      .copyWith(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get bodyBase => (bodySmall ?? const TextStyle())
      .copyWith(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0);
  TextStyle get bodyBaseStrong => (bodySmall ?? const TextStyle())
      .copyWith(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get bodySmallStrong => (bodySmall ?? const TextStyle())
      .copyWith(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0);

  // Label
  TextStyle get labelStrong => (labelLarge ?? const TextStyle())
      .copyWith(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get labelMediumStrong => (labelMedium ?? const TextStyle())
      .copyWith(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get labelBase => (labelSmall ?? const TextStyle())
      .copyWith(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0);
  TextStyle get labelBaseStrong => (labelSmall ?? const TextStyle())
      .copyWith(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get labelSmallStrong => (labelSmall ?? const TextStyle())
      .copyWith(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0);

  // Table
  TextStyle get tableBase => (bodyMedium ?? const TextStyle())
      .copyWith(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0);
  TextStyle get tableBaseStrong => (bodyMedium ?? const TextStyle())
      .copyWith(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0);
  TextStyle get tableSmall => (bodySmall ?? const TextStyle())
      .copyWith(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0);
  TextStyle get tableSmallStrong => (bodySmall ?? const TextStyle())
      .copyWith(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0);
}