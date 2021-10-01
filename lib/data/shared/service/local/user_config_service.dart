import 'package:shared_preferences/shared_preferences.dart';

/// Use this class to store simple key-value preferences
/// that will only be persisted locally during the user session
class UserConfigService {
  final SharedPreferences _sharedPreferences;

  const UserConfigService(this._sharedPreferences);

  static const String _kDataCollectionEnabledKey = "dataCollectionEnabled";

  Future<bool> isDataCollectionEnabled() async {
    return _sharedPreferences.getBool(_kDataCollectionEnabledKey) ?? false;
  }

  Future<void> saveDataCollectionEnabled(bool isEnabled) async {
    _sharedPreferences.setBool(_kDataCollectionEnabledKey, isEnabled);
  }

  Future<void> clear() async {
    await Future.wait([
      _sharedPreferences.remove(_kDataCollectionEnabledKey),
    ]);
  }
}
