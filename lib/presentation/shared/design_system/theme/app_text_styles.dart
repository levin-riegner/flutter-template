import 'package:flutter/material.dart';

abstract class AppTextStyles {
  const AppTextStyles._();

  static const primaryFontFamily = "WorkSans";
  static const fontFamilyFallback = ["Roboto"];

  static TextStyle displayLarge({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 36,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextStyle displayMedium({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextStyle displaySmall({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 24,
      height: 1.2,
      letterSpacing: 0.0,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextStyle bodyLarge({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      height: 1.4,
      letterSpacing: 0.0,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextStyle bodyMedium({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      height: 1.2,
      letterSpacing: 0.0,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextStyle labelSmall({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      height: 1.2,
      letterSpacing: 0.0,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }

  static TextStyle titleMedium({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      height: 1.4,
      color: textColor,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: const [primaryFontFamily, ...fontFamilyFallback],
    );
  }

  // Additional Text Styles outside of the Theme
  static TextStyle homeCirclesText({
    required Color textColor,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 18,
      height: 1.4,
      color: textColor,
      fontStyle: FontStyle.normal,
      fontFamily: primaryFontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }
}
