import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Generic
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  Map<String, dynamic>? getJson(String key) {
    final str = _prefs.getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  List<Map<String, dynamic>>? getJsonList(String key) {
    final str = _prefs.getString(key);
    if (str == null) return null;
    final list = jsonDecode(str) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<bool> remove(String key) => _prefs.remove(key);

  // Keys
  static const onboardingCompleted = 'onboarding_completed';
  static const isPremium = 'is_premium';
  static const favoriteIds = 'favorite_ids';
  static const customAffirmations = 'custom_affirmations';
  static const dailyEntries = 'daily_entries';
  static const sessionCount = 'session_count';
  static const lastReviewPrompt = 'last_review_prompt';
  static const morningCompleted = 'morning_completed';
  static const eveningCompleted = 'evening_completed';
  static const lastCompletionDate = 'last_completion_date';
  static const currentStreak = 'current_streak';
  static const longestStreak = 'longest_streak';
  static const totalDays = 'total_days';
  static const notificationsEnabled = 'notifications_enabled';
  static const quietHoursEnabled = 'quiet_hours_enabled';
  static const quietHoursStart = 'quiet_hours_start';
  static const quietHoursEnd = 'quiet_hours_end';
  static const dailyAffirmationIndex = 'daily_affirmation_index';
  static const dailyAffirmationDate = 'daily_affirmation_date';
  static const dailyViewCount = 'daily_view_count';
  static const dailyViewDate = 'daily_view_date';
}
