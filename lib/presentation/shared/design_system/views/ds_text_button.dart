import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/dimens.dart';

import 'ds_loading_indicator.dart';

// TODO: Refactor class (move to ds_button.dart)
class DSTextButton extends StatelessWidget {
  final String text;
  final double? width;
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onPressed;
  final Alignment alignment;
  final double horizontalMargin;

  final Color? loadingColor;
  final double? height;
  final TextStyle? textStyle;
  final Color? defaultTextColor;
  final Color? disabledTextColor;
  final bool forceUpperCase;

  const DSTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.alignment = Alignment.centerLeft,
    this.horizontalMargin = 0.0,
    this.loadingColor,
    this.height,
    this.textStyle,
    this.defaultTextColor,
    this.disabledTextColor,
    this.forceUpperCase = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? Dimens.buttonHeight,
      child: Align(
        alignment: alignment,
        child: isLoading
            ? DSLoadingIndicator(
                color: loadingColor ?? Theme.of(context).colorScheme.primary)
            : CupertinoButton(
                padding: EdgeInsets.all(horizontalMargin),
                onPressed: (enabled && !isLoading) ? onPressed : null,
                child: Text(
                  forceUpperCase ? text.toUpperCase() : text,
                  style: textStyle ??
                      Theme.of(context).textTheme.button!.copyWith(
                          color: enabled
                              ? (defaultTextColor ??
                                  Theme.of(context).colorScheme.primary)
                              : (disabledTextColor ??
                                  Theme.of(context).disabledColor)),
                ),
              ),
      ),
    );
  }
}
