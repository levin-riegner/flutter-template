import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';

class DSDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? positiveCallback;
  final VoidCallback? negativeCallback;

  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final TextStyle? positiveButtonTextStyle;
  final TextStyle? negativeButtonTextStyle;
  final bool forceUpperCaseButtons;
  final bool? isPositiveButtonLoading;
  final bool? isNegativeButtonLoading;

  const DSDialog({
    Key? key,
    this.title,
    this.description,
    this.positiveButtonText,
    this.negativeButtonText,
    this.positiveCallback,
    this.negativeCallback,
    this.backgroundColor,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.positiveButtonTextStyle,
    this.negativeButtonTextStyle,
    this.forceUpperCaseButtons = true,
    this.isPositiveButtonLoading,
    this.isNegativeButtonLoading,
  })  : assert(title != null || description != null),
        assert((positiveButtonText != null && positiveCallback != null) ||
            (negativeButtonText != null && negativeCallback != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.marginLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (title != null) ...[
                Text(
                  title!,
                  style: titleTextStyle ??
                      Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.87)),
                ),
                const SizedBox(height: Dimens.marginMedium),
              ],
              if (description != null)
                Text(
                  description!,
                  style: descriptionTextStyle ??
                      Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6)),
                ),
              const SizedBox(height: Dimens.marginLarge),
              if (positiveButtonText != null && positiveCallback != null) ...[
                DSPrimaryButton(
                  text: positiveButtonText!,
                  onPressed: positiveCallback,
                  forceUpperCase: forceUpperCaseButtons,
                  isLoading: isPositiveButtonLoading ?? false,
                ),
              ],
              if (negativeButtonText != null && negativeCallback != null) ...[
                const SizedBox(height: Dimens.marginSmall),
                DSTextButton(
                  text: negativeButtonText!,
                  onPressed: negativeCallback,
                  alignment: Alignment.center,
                  forceUpperCase: forceUpperCaseButtons,
                  isLoading: isNegativeButtonLoading ?? false,
                  textStyle: negativeButtonTextStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
