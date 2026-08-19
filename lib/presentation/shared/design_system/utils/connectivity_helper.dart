import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static Future<bool> isConnected() {
    return Connectivity().checkConnectivity().then((connectivityResults) {
      final internetAvailable = connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi);
      return internetAvailable;
    });
  }

  static Stream<bool> onIsConnectedChanged() {
    return Connectivity()
        .onConnectivityChanged
        .map((connectivityResults) => connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi));
  }
}
