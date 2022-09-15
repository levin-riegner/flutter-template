import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static Future<bool> isConnected() {
    return Connectivity().checkConnectivity().then((connectivityResult) {
      final internetAvailable = connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
      return internetAvailable;
    });
  }

  static Stream<bool> onIsConnectedChanged() {
    return Connectivity()
        .onConnectivityChanged
        .map((connectivityResult) => connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
  }
}
