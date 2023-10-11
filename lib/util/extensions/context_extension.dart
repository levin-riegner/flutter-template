import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Strings get l10n => Strings.of(this)!;
  NavigatorState get navigator => Navigator.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  FlutterView get view => View.of(this);
  FocusScopeNode get focusScope => FocusScope.of(this);
  FocusNode get focusNode => Focus.of(this);
  GoRouter get router => GoRouter.of(this);
}
