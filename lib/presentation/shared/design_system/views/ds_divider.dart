import 'package:flutter/material.dart';
import 'package:color_picker/presentation/shared/design_system/theme/dimens.dart';

class DSDivider extends StatelessWidget {
  final double margin;
  final double? height;
  final Color? color;

  const DSDivider({
    super.key,
    this.margin = 0.0,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: Container(
        height: height ?? Dimens.dividerHeight,
        color: color ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      ),
    );
  }
}
