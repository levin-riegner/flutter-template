import 'dart:async';

import 'package:flutter_template/util/tools/custom_tabs_launcher.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:rxdart/subjects.dart';

class DeepLinkManager {
  final String uriScheme;

  DeepLinkManager({
    required this.uriScheme,
  });

  final BehaviorSubject<String?> _deeplink = BehaviorSubject.seeded(null);
  Stream<String?> get deeplink => _deeplink.stream;

  Future<void> handleDeepLink(Uri uri) async {
    Flogger.i("Handle deeplink: $uri");
    switch (_getType(uri)) {
      case _DeepLinkType.app:
        final deeplink = _mapAppDeepLinkToNavigationPath(uri);
        _deeplink.add(deeplink);
        break;
      case _DeepLinkType.external:
        CustomTabsLauncher.instance.launchURL(uri.toString());
        break;
    }
  }

  // Use this method to retrieve and consume a deeplink
  // later in the app lifecycle (e.g. after login)
  String? getCurrentDeeplink({required bool consume}) {
    final link = _deeplink.value;
    if (consume) {
      _deeplink.add(null);
    }
    return link;
  }

  void dispose() {
    _deeplink.close();
  }
}

enum _DeepLinkType { app, external }

extension DeepLinkManagerMapper on DeepLinkManager {
  _DeepLinkType _getType(Uri uri) {
    if (uri.scheme == uriScheme) {
      return _DeepLinkType.app;
    } else {
      Flogger.w("Unexpected deeplink type: $uri");
      return _DeepLinkType.external;
    }
  }

  String _mapAppDeepLinkToNavigationPath(Uri uri) {
    return uri.toString().replaceAll("$uriScheme://", "/");
  }
}
