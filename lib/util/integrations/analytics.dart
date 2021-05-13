import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logging_flutter/flogger.dart';

abstract class Analytics {
  const Analytics._();

  static final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

  static Future<void> identify(String userId, String email) async {
    Flogger.i("Identifying user for Analytics");
    if (kReleaseMode) {
      await firebaseAnalytics.setUserId(userId);
    }
  }

  static Future<void> setCollectionEnabled(bool enabled) async {
    Flogger.i("Setting Analytics collection enabled? $enabled");
    await firebaseAnalytics.setAnalyticsCollectionEnabled(enabled);
  }

  static Future<void> logout() async {
    Flogger.i("Clearing user from Analytics");
    firebaseAnalytics.setUserId(null);
  }

  static setCurrentScreenName(String screenName) {
    Flogger.i("Setting current screen name to: $screenName");
    if (kReleaseMode) {
      firebaseAnalytics.setCurrentScreen(screenName: screenName);
    }
  }

  /// Tracks an Event to all Analytics Providers
  /// Sample Usage:
  //  Analytics.trackEvent(
  //    eventName: AnalyticsEvent.selectItem,
  //    parameters: {AnalyticsParameter.itemId: item.id},
  //  );
  trackEvent({required String eventName, Map<String, dynamic>? parameters}) {
    Flogger.info(eventName, object: parameters);
    if (kReleaseMode) {
      // Track in Analytics Services
      firebaseAnalytics.logEvent(name: eventName, parameters: parameters);
    }
  }
}

abstract class AnalyticsScreen {
  const AnalyticsScreen._();

  static const String articles = "articles";
  static const String articleDetail = "article_detail";
}

// IMPORTANT: Analytics events and properties cannot contain whitespaces.
// Better to always use snake_case for every text analytics-related
abstract class AnalyticsEvent {
  const AnalyticsEvent._();

  static const String selectItem = "item_selected";
}

abstract class AnalyticsParameter {
  const AnalyticsParameter._();

  static const String itemId = "item_id";
}

abstract class AnalyticsValue {
  const AnalyticsValue._();

  static const String article = "article";
}
