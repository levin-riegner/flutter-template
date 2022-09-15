import 'package:flutter/widgets.dart';

class Dimens {
  // Margins
  static const double marginXxxSmall = 2;
  static const double marginXxSmall = 4;
  static const double marginXSmall = 8;
  static const double marginSmall = 12;
  static const double marginMedium = 16;
  static const double marginLarge = 24;
  static const double marginXLarge = 32;
  static const double marginXxLarge = 48;
  static const double marginXxxLarge = 64;

  static SizedBox get boxXxxSmall =>
      const SizedBox(height: marginXxxSmall, width: marginXxxSmall);

  static SizedBox get boxXxSmall =>
      const SizedBox(height: marginXxSmall, width: marginXxSmall);

  static SizedBox get boxXSmall =>
      const SizedBox(height: marginXSmall, width: marginXSmall);

  static SizedBox get boxSmall =>
      const SizedBox(height: marginSmall, width: marginSmall);

  static SizedBox get boxMedium =>
      const SizedBox(height: marginMedium, width: marginMedium);

  static SizedBox get boxLarge =>
      const SizedBox(height: marginLarge, width: marginLarge);

  static SizedBox get boxXLarge =>
      const SizedBox(height: marginXLarge, width: marginXLarge);

  static SizedBox get boxXxLarge =>
      const SizedBox(height: marginXxLarge, width: marginXxLarge);

  static SizedBox get boxXxxLarge =>
      const SizedBox(height: marginXxxLarge, width: marginXxxLarge);

  // Other app-wide dimensions
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;

  static const double listItemHeight = 48;
  static const double listItemHeightLarge = 72;
  static const double listItemHeightXLarge = 96;
  static const double dividerHeight = 1;

  static const double buttonHeight = 48;
  static const double buttonMinWidth = 88;

  static const double iconSize = 24;
  static const double horizontalProgressHeight = 2;
  static const double borderSmall = 1.5;
  static const double navigationBarElevation = 0;
  static const double appBarHeight = 56;

  // View-specific dimensions
  static const double articleCardHeight = 275;
}
