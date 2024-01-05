import 'package:flutter/widgets.dart';

abstract class Anims {
  const Anims._();
  // Durations
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration tapDuration = Duration(milliseconds: 200);

  // Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve tapCurve = Curves.fastEaseInToSlowEaseOut;
}
