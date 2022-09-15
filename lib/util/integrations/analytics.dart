import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logging_flutter/logging_flutter.dart';

abstract class Analytics {
  const Analytics._();

  static Future<void> identify(String userId, String email) async {
    Flogger.i("Identifying user for Analytics");
    if (kReleaseMode) {
      await FirebaseAnalytics.instance.setUserId(
        id: userId,
      );
    }
  }

  static Future<void> setCollectionEnabled(bool enabled) async {
    Flogger.i("Setting Analytics collection enabled? $enabled");
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
  }

  static Future<void> logout() async {
    Flogger.i("Clearing user from Analytics");
    FirebaseAnalytics.instance.setUserId(
      id: null,
    );
  }

  static setCurrentScreenName(String screenName) {
    Flogger.i("Setting current screen name to: $screenName");
    if (kReleaseMode) {
      FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
    }
  }

  /// Tracks an Event to all Analytics Providers
  /// Sample Usage:
  //  Analytics.trackEvent(
  //    eventName: AnalyticsEvent.selectItem,
  //    parameters: {AnalyticsParameter.itemId: item.id},
  //  );
  trackEvent({required String eventName, Map<String, dynamic>? parameters}) {
    Flogger.i("Analytics Event $eventName with params: $parameters");
    if (kReleaseMode) {
      // Track in Analytics Services
      FirebaseAnalytics.instance
          .logEvent(name: eventName, parameters: parameters);
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
