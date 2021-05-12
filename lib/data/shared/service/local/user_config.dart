import 'package:shared_preferences/shared_preferences.dart';

/// Use this class to store simple key-value preferences
/// that will only be persisted locally during the user session
class UserConfig {
  static const String _kDataCollectionEnabledKey = "dataCollectionEnabled";

  Future<bool> isDataCollectionEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDataCollectionEnabledKey) ?? false;
  }

  Future<void> saveDataCollectionEnabled(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kDataCollectionEnabledKey, isEnabled);
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
