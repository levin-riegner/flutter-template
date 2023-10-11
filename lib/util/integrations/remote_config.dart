import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  final FirebaseRemoteConfig _config;

  RemoteConfig(this._config);

  /// Sets the Remote Config default values
  /// from the cache configuration
  Future<void> init() async {
    // Set fetch config
    await _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 60),
      ),
    );
    // Set default values
    await _config.setDefaults(
      {for (var v in RemoteConfigParameters.values) v.key: v.defaultValue},
    );
    // Activate
    await _config.activate();
  }

  /// Fetches, caches and actives configuration
  /// from the Remote Config service.
  Future<void> fetchAndActive() async {
    // Fetch and activate
    await _config.fetchAndActivate();
  }

  // region Interface methods
  bool? getBool(RemoteConfigParameters parameter) {
    return _config.getBool(parameter.key);
  }

  double? getDouble(RemoteConfigParameters parameter) {
    return _config.getDouble(parameter.key);
  }

  int? getInt(RemoteConfigParameters parameter) {
    return _config.getInt(parameter.key);
  }

  String? getString(RemoteConfigParameters parameter) {
    return _config.getString(parameter.key);
  }
  // endregion
}

enum RemoteConfigParameters {
  minimumAndroidVersion(
    "minimumAndroidVersion",
    "0.0.0",
    "Minimum Android version supported. Users on older versions will be forced to update.",
  ),
  minimumIosVersion(
    "minimumIosVersion",
    "0.0.0",
    "Minimum iOS version supported. Users on older versions will be forced to update.",
  ),
  ;

  final String key;
  final dynamic defaultValue;
  final String? description;

  const RemoteConfigParameters(this.key, this.defaultValue, this.description);
}
