import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/data/shared/service/local/user_config_service.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/util/integrations/notifications/installation_api_model.dart';
import 'package:flutter_template/util/integrations/notifications/push_notifications_api_service.dart';
import 'package:flutter_template/util/integrations/notifications/remote_message_model.dart';
import 'package:flutter_template/util/tools/permissions_service.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

typedef OnPushTokenReceived = Function(String token);
typedef OnBranchLinkReceived = Function(String branchLink);

class PushNotificationsHelper {
  final PermissionsService _permissionsService;
  final UserConfigService _userConfigService;
  final PushNotificationsApiService _apiService;

  const PushNotificationsHelper(
    this._permissionsService,
    this._userConfigService,
    this._apiService,
  );

  // region Permission

  /// Requests push notification permission if not requested previously
  /// If the permission is granted, it will call [onPermissionGranted]
  /// If the permission is denied, it will call [onPermissionDenied]
  /// If the permission is already granted or denied, it will do nothing
  /// Optionally, use [defaultOnPermissionGranted] and [defaultOnPermissionDenied] to handle the result
  Future<void> requestPermissionIfNotRequested({
    Function()? onPermissionGranted,
    Function()? onPermissionDenied,
  }) async {
    final requested = await _userConfigService.isPushPermissionRequested();
    if (requested) return;
    // Ensure Google Play Services are available
    if (Platform.isAndroid) {
      try {
        await GoogleApiAvailability.instance.makeGooglePlayServicesAvailable();
      } catch (e) {
        Flogger.i("Google Play Services are not available: $e");
        return;
      }
    }
    Flogger.i("Requesting push notification permission");
    PermissionStatus status =
        await _permissionsService.request(Permission.notification);
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        Flogger.i("Push notification permission granted: $status");
        onPermissionGranted?.call();
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        Flogger.i("Push notification permission denied: $status");
        onPermissionDenied?.call();
        break;
    }
    await _userConfigService.savePushPermissionRequested(true);
  }

  /// Registers the device's push notification token
  /// and additional device information
  Future<void> defaultOnPermissionGranted() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      Flogger.w("Null push token");
      return;
    }
    await saveInstallation(token, enforcePermission: false);
  }

  /// Instructs the user to open the device's app settings
  /// to enable push notifications
  Future<void> defaultOnPermissionDenied() async {
    final context = NavigatorHolder.rootNavigatorKey.currentState?.context;
    if (context == null || !context.mounted) return;
    Flogger.i("Showing push notification settings permission alert");
    AlertService.showAlert(
      context: context,
      message: context.l10n.alertMessagePushNotificationPermanentlyDenied,
      actionText: context.l10n.openSettingsButton,
      onAction: () {
        _permissionsService.openAppSettings();
      },
    );
  }

  // endregion

  // region Token

  /// Subscribes to the device's push notification token changes
  /// Always returns the current token first
  StreamSubscription subscribeToToken(OnPushTokenReceived onTokenReceived) {
    return Rx.merge([
      Stream.fromFuture(
          FirebaseMessaging.instance.getToken().catchError((_) => null)),
      FirebaseMessaging.instance.onTokenRefresh,
    ]).whereNotNull().distinct().listen((event) {
      Flogger.d("Push token: $event");
      onTokenReceived(event);
    });
  }

  /// Registers the device's push notification token and additional device information
  /// Optionally, use [enforcePermission] to discard the token if the permission is not granted
  Future<void> saveInstallation(
    String? token, {
    bool enforcePermission = true,
  }) async {
    try {
      // Ensure we have permission to use the token
      if (enforcePermission) {
        final status =
            await _permissionsService.status(Permission.notification);
        token = switch (status) {
          PermissionStatus.granted ||
          PermissionStatus.limited ||
          PermissionStatus.provisional =>
            token,
          PermissionStatus.denied ||
          PermissionStatus.permanentlyDenied ||
          PermissionStatus.restricted =>
            null,
        };
      }
      Flogger.i("Saving installation ${token != null ? "with" : "w/o"} token");
      final installation = await _buildInstallation(token);
      await _apiService.saveInstallation(installation);
    } catch (e) {
      if (token != null) {
        Flogger.w("Error saving installation: $e");
      }
    }
  }

  /// Removes the device's push notification token
  Future<void> removeInstallation() async {
    try {
      Flogger.i("Removing installation");
      await FirebaseMessaging.instance.deleteToken();
      final installation = await _buildInstallation(null);
      await _apiService.saveInstallation(installation);
    } catch (e) {
      Flogger.w("Error removing installation: $e");
    }
  }

  Future<InstallationApiModel> _buildInstallation(String? token) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return InstallationApiModel(
      fcmToken: token,
      deviceType: Platform.isIOS
          ? InstallationApiDeviceType.ios
          : InstallationApiDeviceType.android,
      appIdentifier: packageInfo.packageName,
      appName: packageInfo.appName,
      appVersion: packageInfo.version,
      osVersion: Platform.isIOS
          ? (await DeviceInfoPlugin().iosInfo).systemVersion
          : (await DeviceInfoPlugin().androidInfo).version.release,
      locale: Platform.localeName,
      timeZone: DateTime.now().timeZoneName,
    );
  }

  // endregion

  // region Messages

  /// Subscribes to incoming push notification messages
  StreamSubscription subscribeToMessages(
    OnBranchLinkReceived onBranchLinkReceived,
  ) {
    // App is terminated [getInitialMessage()] or in background [onMessageOpenedApp]
    final backgroundSubscription = Rx.merge([
      Stream.fromFuture(FirebaseMessaging.instance.getInitialMessage()),
      FirebaseMessaging.onMessageOpenedApp,
    ]).whereNotNull().map(RemoteMessageModel.fromFcm).listen((message) {
      Flogger.i("Received background message: $message");
      final branchLink = message.data?.branchLink;
      if (branchLink == null) return;
      onBranchLinkReceived(branchLink);
    });

    // App is in foreground
    final foregroundSubscription = FirebaseMessaging.onMessage
        .map(RemoteMessageModel.fromFcm)
        .listen((message) {
      Flogger.i("Received foreground message: $message");
      // Get notification data
      final notification = message.notification;
      if (notification == null ||
          (notification.title == null && notification.body == null)) return;
      final titleText = notification.body != null ? notification.title : null;
      final messageText = notification.body ?? notification.title ?? "";
      final branchLink = message.data?.branchLink;
      // Present foreground alert
      final context = NavigatorHolder.rootNavigatorKey.currentState?.context;
      if (context == null || !context.mounted) return;
      AlertService.showAlert(
        context: context,
        title: titleText,
        message: messageText,
        actionText: branchLink != null
            ? context.l10n.pushNotificationDeeplinkButton
            : null,
        onAction:
            branchLink != null ? () => onBranchLinkReceived(branchLink) : null,
      );
    });

    return CompositeSubscription()
      ..add(backgroundSubscription)
      ..add(foregroundSubscription);
  }

  // endregion
}
