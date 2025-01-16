import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:logging_flutter/logging_flutter.dart';

typedef OnBranchDeepLink = void Function(Uri uri);

typedef OnBranchUtmParameters = void Function(
  String source,
  String medium,
  String campaign,
);

class BranchApi {
  final String _deeplinkScheme;
  final OnBranchDeepLink onDeepLink;
  final OnBranchUtmParameters onUtmParameters;

  // $ Branch reserved keyword
  // ~ Branch analytical data
  // + Branch added values
  static const List<String> _branchReserverdPrefixes = ["\$", "~", "+"];
  static const String deeplinkPathKey = "\$deeplink_path";
  static const String _nonBranchLinkKey = "+non_branch_link";

  BranchApi(
    this._deeplinkScheme, {
    required this.onDeepLink,
    required this.onUtmParameters,
  });

  StreamSubscription? _branchLinksSubscription;
  Map<dynamic, dynamic>? _lastBranchData;

  /// Listens for Branch events
  Future<void> initBranchSession({
    required bool enableLogging,
  }) async {
    Flogger.i("Init Branch session");
    await FlutterBranchSdk.init(
      enableLogging: enableLogging,
      branchAttributionLevel: BranchAttributionLevel.NONE,
    );
    _branchLinksSubscription = FlutterBranchSdk.listSession().listen(
      onBranchData,
      onError: (error) {
        Flogger.e("Branch error: $error");
      },
      cancelOnError: false,
    );
  }

  /// Manually handle a Branch link
  /// This is useful when links are received via push notifications
  /// or other non-Branch sources
  void handleBranchLink(String link) {
    Flogger.i("Handle Branch link: $link");
    FlutterBranchSdk.handleDeepLink(link);
  }

  @visibleForTesting
  void onBranchData(Map<dynamic, dynamic> data) {
    // Branch will send the same data twice (with slight metadata variations!)
    // when the app is minimized and resumed again
    if (_lastBranchData != null && _isDataEquals(data, _lastBranchData!)) {
      Flogger.d("Ignoring already handled branch data");
      return;
    }
    _lastBranchData = Map.from(data);

    if (data['+clicked_branch_link'] == true) {
      Flogger.i("Branch link received: $data");
      onUtmParameters(
        data["~channel"] ?? "Branch", // Source
        data["~feature"] ?? "deeplink", // Medium
        data["~campaign"] ?? "", // Campaign
      );
      final uri = Uri.tryParse(data[deeplinkPathKey] ?? "");
      if (uri != null && uri.toString().isNotEmpty) {
        Flogger.i("Branch deeplink received: $uri");
        final uriWithQueryParameters = _appendDataToQueryParameteres(uri, data);
        onDeepLink(uriWithQueryParameters);
      } else {
        Flogger.e("Failed to parse deeplink_path: ${data[deeplinkPathKey]}");
      }
    } else if (data.containsKey(_nonBranchLinkKey)) {
      final uri = Uri.tryParse(data[_nonBranchLinkKey]);
      if (uri != null && uri.scheme == _deeplinkScheme) {
        Flogger.i("Non-Branch deeplink received: $uri");
        onDeepLink(uri);
      } else {
        Flogger.i("Ignoring non-branch deeplink: ${data[_nonBranchLinkKey]}");
      }
    }
  }

  Uri _appendDataToQueryParameteres(Uri uri, Map<dynamic, dynamic> data) {
    final queryParameters = Map<String, String>.from(uri.queryParameters);
    // Remove branch properties
    data.removeWhere(
      (key, value) =>
          value == null ||
          key is! String ||
          _branchReserverdPrefixes.any((prefix) => key.startsWith(prefix)),
    );
    // Add custom data to query parameters
    data.forEach(
      (key, value) => queryParameters[key] = value.toString(),
    );
    if (queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: queryParameters);
  }

  bool _isDataEquals(Map<dynamic, dynamic> left, Map<dynamic, dynamic> right) {
    if (left[deeplinkPathKey] != right[deeplinkPathKey]) {
      return false;
    }
    if (left[_nonBranchLinkKey] != right[_nonBranchLinkKey]) {
      return false;
    }
    if (left['+clicked_branch_link'] != right['+clicked_branch_link']) {
      return false;
    }
    if (left["~channel"] != right["~channel"]) {
      return false;
    }
    if (left["~feature"] != right["~feature"]) {
      return false;
    }
    if (left["~campaign"] != right["~campaign"]) {
      return false;
    }
    return true;
  }

  void dispose() {
    _branchLinksSubscription?.cancel();
    _branchLinksSubscription = null;
    _lastBranchData = null;
  }
}
