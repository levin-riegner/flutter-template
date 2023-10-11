import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';

class AlertService {
  AlertService._();

  static const int _durationSeconds = 3;
  static const int _durationWithActionsSeconds = 6;

  static void showAlert({
    required BuildContext context,
    required String message,
    AlertType type = AlertType.success,
    String? title,
    int? seconds,
    String? actionText,
    VoidCallback? onAction,
    Color? backgroundColor,
    Color? textColor,
    double? snackBarElevation,
    ShapeBorder? snackBarShape,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    TextAlign? textAlign,
    BorderRadius? borderRadius,
    AlertStyle style = AlertStyle.topBar,
  }) {
    seconds = seconds ??
        (onAction == null ? _durationSeconds : _durationWithActionsSeconds);
    backgroundColor = backgroundColor ??
        (type == AlertType.error
            ? context.colorScheme.error
            : context.colorScheme.primary);
    textColor = textColor ??
        (type == AlertType.error
            ? context.colorScheme.onError
            : context.colorScheme.onPrimary);
    switch (style) {
      case AlertStyle.topBar:
        // Declare variable to avoid compiler error:
        // Local variable 'flushBar' can't be referenced before it is declared.
        late final Flushbar flushBar;
        flushBar = Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          animationDuration: const Duration(milliseconds: 500),
          margin: margin?.resolve(TextDirection.ltr) ??
              const EdgeInsets.all(
                Dimens.marginMedium,
              ),
          padding: padding?.resolve(TextDirection.ltr) ??
              const EdgeInsets.all(
                Dimens.marginLarge,
              ),
          titleText: title == null
              ? null
              : Text(
                  title,
                  textAlign: textAlign ?? TextAlign.center,
                  style: context.textTheme.headlineMedium
                      ?.copyWith(color: textColor),
                ),
          messageText: Text(
            message,
            textAlign: textAlign ?? TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
          ),
          backgroundColor: backgroundColor,
          onTap: onAction != null ? (_) => onAction() : null,
          mainButton: (onAction != null && actionText != null)
              ? TextButton(
                  onPressed: onAction,
                  child: Text(
                    actionText,
                    style:
                        context.textTheme.labelLarge?.apply(color: textColor),
                  ),
                )
              : null,
          borderRadius: borderRadius ??
              BorderRadius.circular(
                Dimens.snackBarBorderRadius,
              ),
          isDismissible: true,
          shouldIconPulse: false,
        )..show(context);
        break;
      case AlertStyle.snackBar:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: snackBarElevation,
            shape: snackBarShape,
            margin: margin,
            padding: padding,
            duration: Duration(seconds: seconds),
            backgroundColor: backgroundColor,
            content: Text(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textColor),
              message,
              textAlign: textAlign,
            ),
            action: (onAction != null && actionText != null)
                ? SnackBarAction(
                    label: actionText,
                    onPressed: onAction,
                    textColor: textColor,
                  )
                : null,
          ),
        );
        break;
    }
  }
}

enum AlertStyle {
  topBar,
  snackBar,
}

enum AlertType {
  success,
  error,
}
