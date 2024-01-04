import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/app_colors.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/app_text_styles.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/app_theme.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';

abstract class ThemeFactory {
  static SystemUiOverlayStyle lightSystemUIOverlayStyle =
      SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
  );
  static SystemUiOverlayStyle darkSystemUIOverlayStyle =
      SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
  );

  static ThemeData lightTheme() {
    const defaultTextColor = AppColors.black;

    // Basic Config
    final base = ThemeData.light().copyWith(
      disabledColor: AppColors.disabled,
      colorScheme: const ColorScheme(
        primary: AppColors.yellow,
        secondary: AppColors.accent,
        surface: AppColors.white,
        background: AppColors.white,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onSurface: AppColors.black,
        onBackground: AppColors.black,
        onError: AppColors.white,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(textColor: defaultTextColor),
        displayMedium: AppTextStyles.displayMedium(textColor: defaultTextColor),
        displaySmall: AppTextStyles.displaySmall(textColor: defaultTextColor),
        bodyLarge: AppTextStyles.bodyLarge(textColor: defaultTextColor),
        bodyMedium: AppTextStyles.bodyMedium(textColor: defaultTextColor),
        labelSmall: AppTextStyles.labelSmall(textColor: defaultTextColor),
        titleMedium: AppTextStyles.titleMedium(textColor: defaultTextColor),
      ),
    );

    // Other Configs
    return base.copyWith(
      brightness: base.colorScheme.brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: base.colorScheme.secondary,
        selectionColor: base.colorScheme.secondary,
        selectionHandleColor: base.colorScheme.secondary,
      ),
      splashFactory: NoSplash.splashFactory,
      primaryColor: base.colorScheme.primary,
      primaryColorLight: base.colorScheme.primary,
      primaryColorDark: base.colorScheme.primary,
      scaffoldBackgroundColor: base.colorScheme.background,
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: true,
        elevation: Dimens.zero,
        systemOverlayStyle: lightSystemUIOverlayStyle,
        iconTheme: base.iconTheme.copyWith(
          color: base.colorScheme.onBackground,
        ),
        actionsIconTheme: base.iconTheme.copyWith(
          color: base.colorScheme.onBackground,
        ),
        backgroundColor: base.colorScheme.background,
        titleTextStyle: base.textTheme.displayMedium,
      ),
      dividerColor: base.disabledColor,
      snackBarTheme: base.snackBarTheme.copyWith(
        elevation: Dimens.zero,
        shape: const BeveledRectangleBorder(),
      ),
      inputDecorationTheme: AppTheme.inputDecorationTheme(
        base.inputDecorationTheme,
        floatingLabelStyle: base.textTheme.labelSmall,
        labelStyle: base.textTheme.bodyLarge,
        errorStyle: base.textTheme.labelSmall,
        errorColor: base.colorScheme.error,
        borderColor: base.colorScheme.onBackground,
        iconColor: base.colorScheme.background,
      ),
      buttonTheme: AppTheme.buttonTheme(
        base.buttonTheme,
        borderColor: base.colorScheme.onBackground,
      ),
    );
  }

  static ThemeData darkTheme() {
    const defaultTextColor = AppColors.white;

    // Basic Config
    final base = ThemeData.dark().copyWith(
      disabledColor: AppColors.disabled,
      colorScheme: const ColorScheme(
        primary: AppColors.yellow,
        secondary: AppColors.accent,
        surface: AppColors.black,
        background: AppColors.black,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.white,
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(textColor: defaultTextColor),
        displayMedium: AppTextStyles.displayMedium(textColor: defaultTextColor),
        displaySmall: AppTextStyles.displaySmall(textColor: defaultTextColor),
        bodyLarge: AppTextStyles.bodyLarge(textColor: defaultTextColor),
        bodyMedium: AppTextStyles.bodyMedium(textColor: defaultTextColor),
        labelSmall: AppTextStyles.labelSmall(textColor: defaultTextColor),
        titleMedium: AppTextStyles.titleMedium(textColor: defaultTextColor),
      ),
    );

    // Other Configs
    return base.copyWith(
      brightness: base.colorScheme.brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: base.colorScheme.secondary,
        selectionColor: base.colorScheme.secondary,
        selectionHandleColor: base.colorScheme.secondary,
      ),
      splashFactory: NoSplash.splashFactory,
      primaryColor: base.colorScheme.primary,
      primaryColorLight: base.colorScheme.primary,
      primaryColorDark: base.colorScheme.primary,
      scaffoldBackgroundColor: base.colorScheme.background,
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: true,
        elevation: Dimens.zero,
        systemOverlayStyle: darkSystemUIOverlayStyle,
        iconTheme: base.iconTheme.copyWith(
          color: base.colorScheme.onBackground,
        ),
        actionsIconTheme: base.iconTheme.copyWith(
          color: base.colorScheme.onBackground,
        ),
        backgroundColor: base.colorScheme.background,
        titleTextStyle: base.textTheme.displayMedium,
      ),
      dividerColor: base.disabledColor,
      snackBarTheme: base.snackBarTheme.copyWith(
        elevation: Dimens.zero,
        shape: const BeveledRectangleBorder(),
      ),
      inputDecorationTheme: AppTheme.inputDecorationTheme(
        base.inputDecorationTheme,
        floatingLabelStyle: base.textTheme.labelSmall,
        labelStyle: base.textTheme.bodyLarge,
        errorStyle: base.textTheme.labelSmall,
        errorColor: base.colorScheme.error,
        borderColor: base.colorScheme.onBackground,
        iconColor: base.colorScheme.background,
      ),
      buttonTheme: AppTheme.buttonTheme(
        base.buttonTheme,
        borderColor: base.colorScheme.onBackground,
      ),
    );
  }
}
