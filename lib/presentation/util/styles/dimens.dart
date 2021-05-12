import 'package:lr_design_system/utils/dimens.dart';

abstract class AppDimens {

  static const double kArticleCardHeight = 275;

  static DimensData regular() {
    return DimensData(
      marginXxxSmall: 1.5,
      marginXxSmall: 1.5,
      marginXSmall: 3,
      marginSmall: 6,
      marginMedium: 12,
      marginLarge: 24,
      marginXLarge: 36,
      marginXxLarge: 48,
      marginXxxLarge: 60,
      radiusSmall: 0,
      radiusMedium: 0,
      radiusLarge: 12,
      radiusXLarge: 24,
      listItemHeight: 48,
      listItemHeightLarge: 64,
      listItemHeightXLarge: 96,
      dividerHeight: 1,
      buttonHeight: 48,
      buttonMinWidth: 88,
      iconSize: 24,
      horizontalProgressHeight: 2,
      borderSmall: 1.5,
      navigationBarElevation: 0,
    );
  }
}
