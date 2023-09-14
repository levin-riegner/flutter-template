import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/util/tools/analytics_event.dart';
import 'package:logging_flutter/logging_flutter.dart';

// Expose AnalyticsEvents to avoid the double import
export 'package:flutter_template/util/tools/analytics_event.dart';

class Analytics {
  static Analytics? _instance;

  static const bool _kReleaseMode = kReleaseMode;

  Analytics._();

  static Analytics get instance => _instance ??= Analytics._();

  static Future<void> identify(String userId, String email) async {
    Flogger.i("Identifying user for Analytics");
    await FirebaseAnalytics.instance.setUserId(
      id: userId,
    );
  }

  static Future<void> setCollectionEnabled(bool enabled) async {
    Flogger.i("Setting collection enabled: $enabled");
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
  }

  static Future<void> logout() async {
    Flogger.i("Clearing user from Analytics");
    await FirebaseAnalytics.instance.setUserId(id: null);
  }

  /// Tracks the current screen change
  String? _lastTrackedScreenName;
  Future<void> setCurrentScreen({
    required String name,
    required String screenClass,
  }) async {
    if (_lastTrackedScreenName == name) {
      return;
    }
    _lastTrackedScreenName = name;
    if (_kReleaseMode) {
      await FirebaseAnalytics.instance.setCurrentScreen(
        screenName: name,
        screenClassOverride: screenClass,
      );
    } else {
      Flogger.i("Setting current screen name: $name with class: $screenClass");
    }
  }

  /// Tracks the UTM parameters from the link that opened the app
  Future<void> trackUtmParameters({
    required String source,
    required String medium,
    required String campaign,
  }) async {
    Flogger.i(
      "Tracking UTM parameters: source=$source, medium=$medium, campaign=$campaign",
    );
    if (_kReleaseMode) {
      await FirebaseAnalytics.instance.logCampaignDetails(
        source: source,
        medium: medium,
        campaign: campaign,
      );
      await FirebaseAnalytics.instance.logAppOpen();
    }
  }

  Future<void> track(AnalyticsEvent event) async {
    if (_kReleaseMode) {
      await FirebaseAnalytics.instance.logEvent(
        name: event.name,
        parameters: event.parameters,
      );
    } else {
      Flogger.i("Track $event");
    }
  }
}
