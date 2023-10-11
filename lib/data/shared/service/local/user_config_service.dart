import 'package:shared_preferences/shared_preferences.dart';

/// Use this class to store simple key-value preferences
/// that will only be persisted locally during the user session
class UserConfigService {
  final SharedPreferences _sharedPreferences;

  const UserConfigService(this._sharedPreferences);

  static const String _kDataCollectionEnabledKey = "dataCollectionEnabled";
  static const String _kPushPermissionRequestedKey = "pushPermissionRequested";

  Future<bool?> isDataCollectionEnabled() async {
    return _sharedPreferences.getBool(_kDataCollectionEnabledKey);
  }

  Future<void> saveDataCollectionEnabled(bool isEnabled) async {
    _sharedPreferences.setBool(_kDataCollectionEnabledKey, isEnabled);
  }

  Future<bool> isPushPermissionRequested() async {
    return _sharedPreferences.getBool(_kPushPermissionRequestedKey) ?? false;
  }

  Future<void> savePushPermissionRequested(bool isRequested) async {
    _sharedPreferences.setBool(_kPushPermissionRequestedKey, isRequested);
  }

  Future<void> clear() async {
    await Future.wait([
      _sharedPreferences.remove(_kDataCollectionEnabledKey),
      _sharedPreferences.remove(_kPushPermissionRequestedKey),
    ]);
  }
}
