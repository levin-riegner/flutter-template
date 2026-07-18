import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ConnectivityHelper {
  // Lightweight hosts to probe. First success wins.
  static const List<String> _probeHosts = [
    'one.one.one.one', // Cloudflare
    'google.com',
    'apple.com',
  ];

  static const Duration _probeTimeout = Duration(seconds: 3);

  // Verifies actual internet reachability, not just interface presence.
  // connectivity_plus alone reports "none" on iOS simulator / some macOS
  // setups even when the device is online, so we double-check with DNS.
  static Future<bool> isConnected() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final hasInterface =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      // If interface reports offline, trust the DNS probe anyway —
      // simulator lies here.
      final reachable = await _hasInternetAccess();
      if (hasInterface != reachable) {
        Flogger.d(
          '[ConnectivityHelper] interface=$hasInterface '
          'reachable=$reachable — trusting reachable',
        );
      }
      return reachable;
    } catch (e) {
      Flogger.d('[ConnectivityHelper] isConnected check failed: $e');
      return false;
    }
  }

  static Stream<bool> onIsConnectedChanged() async* {
    // Emit initial state.
    yield await isConnected();
    // Re-probe on every interface change.
    await for (final _ in Connectivity().onConnectivityChanged) {
      yield await isConnected();
    }
  }

  static Future<bool> _hasInternetAccess() async {
    for (final host in _probeHosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(_probeTimeout);
        if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException {
        continue;
      } on TimeoutException {
        continue;
      }
    }
    return false;
  }
}
