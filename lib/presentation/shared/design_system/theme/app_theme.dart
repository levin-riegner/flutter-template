import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';

abstract class AppTheme {
  const AppTheme._();

  static ButtonThemeData buttonTheme(
    ButtonThemeData base, {
    required Color borderColor,
  }) {
    return base.copyWith(
      height: Dimens.buttonHeight,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.buttonRadius,
        ),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(
    InputDecorationTheme base, {
    required Color borderColor,
    required TextStyle? floatingLabelStyle,
    required TextStyle? labelStyle,
    required TextStyle? errorStyle,
    required Color errorColor,
    required Color iconColor,
  }) {
    return base.copyWith(
      contentPadding: const EdgeInsets.all(
        Dimens.marginMedium,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: Dimens.inputDecorationBorderWidth,
        ),
        borderRadius: BorderRadius.circular(Dimens.inputDecorationRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
          width: Dimens.inputDecorationBorderWidth,
        ),
        borderRadius: BorderRadius.circular(Dimens.inputDecorationRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor.withOpacity(0.5),
          width: Dimens.inputDecorationBorderWidth,
        ),
        borderRadius: BorderRadius.circular(Dimens.inputDecorationRadius),
      ),
      floatingLabelStyle: floatingLabelStyle,
      labelStyle: labelStyle,
      errorStyle: errorStyle?.copyWith(
        color: errorColor,
      ),
      iconColor: iconColor,
      prefixIconColor: iconColor,
      suffixIconColor: iconColor,
    );
  }
}
