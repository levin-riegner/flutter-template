import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';

void main() {
  late StorageService storage;
  late NotificationService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    service = NotificationService(storage);
  });

  group('NotificationService', () {
    test('notifications enabled by default', () {
      expect(service.isEnabled(), true);
    });

    test('setEnabled changes state', () async {
      await service.setEnabled(false);
      expect(service.isEnabled(), false);
    });

    test('quiet hours disabled by default', () {
      expect(service.isQuietHoursEnabled(), false);
    });

    test('setQuietHoursEnabled changes state', () async {
      await service.setQuietHoursEnabled(true);
      expect(service.isQuietHoursEnabled(), true);
    });

    test('default quiet hours', () {
      expect(service.getQuietHoursStart(), 22);
      expect(service.getQuietHoursEnd(), 7);
    });

    test('setQuietHours changes values', () async {
      await service.setQuietHours(23, 8);
      expect(service.getQuietHoursStart(), 23);
      expect(service.getQuietHoursEnd(), 8);
    });
  });
}
