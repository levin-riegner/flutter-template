import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData lightTheme() {
    final defaultTextColor = Color(0xFF000000);
    // Basic Config
    final base = ThemeData.light().copyWith(
      disabledColor: Color(0xFFEFECEA),
      colorScheme: ColorScheme(
        primary: Color(0xFFFEBE10),
        primaryVariant: Color(0xFFFEBE10),
        secondary: Color(0xFFFAA21B),
        secondaryVariant: Color(0xFFFCE8EB),
        surface: Color(0xFFFFFFFF),
        background: Color(0xFFFFFFFF),
        error: Color(0xFFFF5F55),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFF000000),
        onBackground: Color(0xFF000000),
        onError: Color(0xFF000000),
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 36,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        headline2: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 30,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        headline3: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 26,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        headline4: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 22,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        headline5: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        headline6: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        subtitle1: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          letterSpacing: 0,
          height: 1.6,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        subtitle2: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
          letterSpacing: 0,
          height: 1.6,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        bodyText1: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0,
          height: 1.6,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        bodyText2: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0,
          height: 1.6,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        caption: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Akkurat",
          fontFamilyFallback: ["Roboto"],
        ),
        button: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0,
          height: 1.6,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Algebra",
          fontFamilyFallback: ["Roboto"],
        ),
        overline: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          letterSpacing: 0,
          height: 1.4,
          color: defaultTextColor,
          fontStyle: FontStyle.normal,
          fontFamily: "Akkurat",
          fontFamilyFallback: ["Roboto"],
        ),
      ),
    );
    // Other Configs
    return base.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: base.colorScheme.primary,
        selectionColor: base.colorScheme.primary,
        selectionHandleColor: base.colorScheme.primary,
      ),
      splashColor: base.disabledColor,
      primaryColor: base.colorScheme.primary,
      primaryColorLight: base.colorScheme.primary,
      primaryColorDark: base.colorScheme.primary,
      accentColor: base.colorScheme.primary,
      backgroundColor: base.colorScheme.background,
      scaffoldBackgroundColor: base.colorScheme.background,
      bottomAppBarColor: Color(0xFF000000),
      shadowColor: Color(0xFF000000),
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData.fallback().copyWith(
          color: Color(0xFF000000),
        ),
        actionsIconTheme: IconThemeData.fallback().copyWith(
          color: Color(0xFF000000),
        ),
        color: Color(0xFFFEBE10),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: Color(0xFF000000),
        selectedItemColor: Color(0xFFFEBE10),
        unselectedItemColor: Color(0xFFFFFFFF).withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: base.textTheme.overline,
        unselectedLabelStyle: base.textTheme.overline,
        elevation: 0,
      ),
      tooltipTheme: base.tooltipTheme.copyWith(
        textStyle: base.textTheme.overline.copyWith(color: Color(0xFFFFFFFF)),
      ),
      cardColor: base.colorScheme.background,
      dividerColor: base.disabledColor,
      cardTheme: base.cardTheme.copyWith(
        elevation: 0.0,
        color: base.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: base.colorScheme.onPrimary.withOpacity(.3), width: 1.0),
          borderRadius: BorderRadius.zero,
        ),
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        elevation: 0.0,
        shape: BeveledRectangleBorder(),
        backgroundColor: base.colorScheme.onBackground,
        contentTextStyle: base.textTheme.caption.copyWith(
          color: base.colorScheme.background,
        ),
      ),
    );
  }
}
