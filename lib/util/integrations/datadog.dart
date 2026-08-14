import 'dart:io' show Platform;
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:color_picker/app/config/environment.dart';
import 'package:logging_flutter/logging_flutter.dart';

class Datadog {
  static DatadogLogger? _logger;

  const Datadog._();

  /// datadog_flutter_plugin supports android/ios/web only.
  /// On Linux/Windows the native part is absent — calls are no-ops.
  static bool get _unsupported => Platform.isLinux || Platform.isWindows;

  static Future<void> initialize({
    required DatadogConfig config,
    required String environment,
  }) async {
    if (_unsupported) return;
    await DatadogSdk.instance.initialize(
      DatadogConfiguration(
        clientToken: config.clientToken,
        env: environment.toLowerCase(),
        site: DatadogSite.us1,
        nativeCrashReportEnabled: false,
        loggingConfiguration: DatadogLoggingConfiguration(),
        rumConfiguration: null,
      ),
      TrackingConsent.pending,
    );
    _logger = DatadogSdk.instance.logs?.createLogger(
      DatadogLoggerConfiguration(
        service: "Flutter-$environment",
        name: "Flutter-$environment",
        networkInfoEnabled: true,
        bundleWithRumEnabled: false,
        remoteLogThreshold: LogLevel.info,
      ),
    );
  }

  static Future<void> setTrackingConsent(bool? dataCollectionEnabled) async {
    if (_unsupported) return;
    TrackingConsent trackingConsent = TrackingConsent.pending;
    if (dataCollectionEnabled != null) {
      trackingConsent = dataCollectionEnabled
          ? TrackingConsent.granted
          : TrackingConsent.notGranted;
    }
    DatadogSdk.instance.setTrackingConsent(trackingConsent);
  }

  static Future<void> logRecord(String message, Level level) async {
    if (_unsupported) return;
    if (level == Level.SEVERE) {
      _logger?.error(message);
    } else if (level == Level.WARNING) {
      _logger?.warn(message);
    } else if (level == Level.INFO) {
      _logger?.info(message);
    } else {
      // Ignore other levels
    }
  }

  static Future<void> identify({
    required String userId,
    String? name,
    String? email,
  }) async {
    if (_unsupported) return;
    DatadogSdk.instance.setUserInfo(id: userId, name: name, email: email);
  }

  static void clearUser() {
    if (_unsupported) return;
    // datadog_flutter_plugin 2.16.1 removed clearUserInfo; clearing is done by
    // setting all user fields to null.
    DatadogSdk.instance.setUserInfo(id: null, name: null, email: null);
  }
}
