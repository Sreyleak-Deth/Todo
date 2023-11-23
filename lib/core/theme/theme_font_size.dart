import 'package:flutter/material.dart';
import 'package:todo_list/core/theme/theme_font.dart';

class ThemeFontSize {
  static TextTheme get textTheme {
    return const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        fontFamily: ThemeFont.defaultFontFamily,
      ),
    );
  }
}
