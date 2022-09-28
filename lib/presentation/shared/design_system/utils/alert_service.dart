import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AlertService {
  AlertService._();

  static const int _durationSeconds = 3;
  static const int _durationWithActionsSeconds = 6;

  static void showAlert({
    required BuildContext context,
    required String message,
    String? title,
    int? seconds,
    String? actionText,
    VoidCallback? onAction,
    Color? backgroundColor,
    Color? actionTextColor,
    double? snackBarElevation,
    ShapeBorder? snackBarShape,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    TextAlign? textAlign,
    AlertType type = AlertType.topBar,
  }) {
    seconds = seconds ??
        (onAction == null ? _durationSeconds : _durationWithActionsSeconds);
    switch (type) {
      case AlertType.topBar:
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle:
              margin != null ? FlushbarStyle.FLOATING : FlushbarStyle.GROUNDED,
          animationDuration: const Duration(milliseconds: 500),
          margin:
              margin?.resolve(TextDirection.ltr) ?? const EdgeInsets.all(0.0),
          padding:
              padding?.resolve(TextDirection.ltr) ?? const EdgeInsets.all(16),
          titleText: title == null
              ? null
              : Text(
                  title,
                  textAlign: textAlign ?? TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
          messageText: Text(
            message,
            textAlign: textAlign ?? TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.primary,
          duration: Duration(seconds: seconds),
          onTap: (_) => onAction!(),
          mainButton: (onAction != null && actionText != null)
              ? TextButton(
                  onPressed: onAction,
                  child: Text(
                    actionText,
                    style: Theme.of(context).textTheme.button!.apply(
                        color: actionTextColor ??
                            Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.5)),
                  ),
                )
              : null,
        ).show(context);
        break;
      case AlertType.snackBar:
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
              message,
              textAlign: textAlign,
            ),
            action: (onAction != null && actionText != null)
                ? SnackBarAction(
                    label: actionText,
                    onPressed: onAction,
                    textColor: actionTextColor ??
                        Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        );
        break;
    }
  }
}

enum AlertType {
  topBar,
  snackBar,
}
