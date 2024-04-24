import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

mixin UserNotConfirmedInterceptor {
  Future<void> onUserNotConfirmedException({
    bool shouldRedirect = true,
  }) async {
    final context = NavigatorHolder.rootNavigatorKey.currentState!.context;

    if (shouldRedirect) {
      if (!context.mounted) return;
      context.go(
        const OtpVerificationRoute(
          // Send OTP to email as soon as the screen is shown
          sendCodeOnInit: true,
        ).location,
      );
      // Give some time for the navigation to complete and show alert
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!context.mounted) return;
    AlertService.showAlert(
      context: context,
      title: context.l10n.unconfirmedAccountAlertTitle,
      message: context.l10n.unconfirmedAccountAlertDescription,
      type: AlertType.error,
    );
  }
}
