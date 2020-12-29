import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/util/tools/flogger.dart';
import 'package:meta/meta.dart';

abstract class Analytics {

  static final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

  /// Tracks an Event to all Analytics Providers
  /// Sample Usage:
  //  Analytics.trackEvent(
  //    eventName: AnalyticsEvent.selectItem,
  //    parameters: {AnalyticsParameter.itemId: item.id},
  //  );
  trackEvent({@required String eventName, Map<String, dynamic> parameters}) {
    Flogger.info(eventName, object: parameters);
    if (kReleaseMode) {
      // Track in Analytics Services
      firebaseAnalytics.logEvent(name: eventName, parameters: parameters);
    }
  }
}

abstract class AnalyticsEvent {
  // Example
  static const String selectItem = "Item_Selected";
}

abstract class AnalyticsParameter {
  // Example
  static const String itemId = "Item_Id";
}