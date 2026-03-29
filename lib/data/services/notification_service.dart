import 'package:affirmup/data/services/storage_service.dart';

class NotificationService {
  final StorageService _storage;

  NotificationService(this._storage);

  static const int defaultMorningHour = 8;
  static const int defaultMorningMinute = 0;
  static const int defaultEveningHour = 21;
  static const int defaultEveningMinute = 0;

  bool isEnabled() {
    return _storage.getBool(StorageService.notificationsEnabled) ?? true;
  }

  Future<void> setEnabled(bool value) async {
    await _storage.setBool(StorageService.notificationsEnabled, value);
  }

  bool isQuietHoursEnabled() {
    return _storage.getBool(StorageService.quietHoursEnabled) ?? false;
  }

  Future<void> setQuietHoursEnabled(bool value) async {
    await _storage.setBool(StorageService.quietHoursEnabled, value);
  }

  int getQuietHoursStart() {
    return _storage.getInt(StorageService.quietHoursStart) ?? 22;
  }

  int getQuietHoursEnd() {
    return _storage.getInt(StorageService.quietHoursEnd) ?? 7;
  }

  Future<void> setQuietHours(int start, int end) async {
    await _storage.setInt(StorageService.quietHoursStart, start);
    await _storage.setInt(StorageService.quietHoursEnd, end);
  }

  /// Mock: schedule morning notification
  Future<void> scheduleMorningNotification() async {
    // Would use flutter_local_notifications in production
  }

  /// Mock: schedule evening notification
  Future<void> scheduleEveningNotification() async {
    // Would use flutter_local_notifications in production
  }

  /// Mock: cancel all notifications
  Future<void> cancelAll() async {
    // Would cancel all scheduled notifications
  }
}
