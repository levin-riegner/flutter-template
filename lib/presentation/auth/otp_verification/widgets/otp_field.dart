import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:pinput/pinput.dart';

class OtpField extends StatelessWidget {
  final Function(String) onCompleted;
  final Function(String)? onSubmitted;
  final VoidCallback? onLocalValidationSuccess;
  final VoidCallback? onLocalValidationFailure;
  final int length;
  final double cellSpacing;

  const OtpField({
    super.key,
    required this.onCompleted,
    this.length = 6,
    this.cellSpacing = Dimens.marginXxxSmall,
    this.onLocalValidationSuccess,
    this.onLocalValidationFailure,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      defaultPinTheme: PinTheme(
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(
            Dimens.otpFieldBorderRadius,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.marginMedium,
          horizontal: Dimens.marginMedium,
        ),
        textStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSecondary,
          fontWeight: FontWeight.bold,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: cellSpacing,
        ),
        constraints: BoxConstraints(
          minWidth: context.mediaQuery.size.width / length,
          minHeight: context.textTheme.bodyMedium?.fontSize ?? 0,
        ),
      ),
      length: length,
      autofocus: true,
      keyboardType: TextInputType.number,
      onChanged: (val) {
        if (val.length == length) {
          if (onLocalValidationSuccess != null) {
            onLocalValidationSuccess!();
          }
        } else {
          if (onLocalValidationFailure != null) {
            onLocalValidationFailure!();
          }
        }
      },
      onSubmitted: onSubmitted,
      onCompleted: onCompleted,
      listenForMultipleSmsOnAndroid: true,
      pinAnimationType: PinAnimationType.fade,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
