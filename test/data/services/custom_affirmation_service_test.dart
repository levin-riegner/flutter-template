import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';

void main() {
  late StorageService storage;
  late CustomAffirmationService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    service = CustomAffirmationService(storage);
  });

  group('CustomAffirmationService', () {
    test('starts with no custom affirmations', () {
      expect(service.getCustomAffirmations(), isEmpty);
    });

    test('saves custom affirmation', () async {
      await service.saveCustomAffirmation('I am powerful');
      final customs = service.getCustomAffirmations();
      expect(customs.length, 1);
      expect(customs.first.text, 'I am powerful');
    });

    test('deletes custom affirmation', () async {
      await service.saveCustomAffirmation('I am powerful');
      final customs = service.getCustomAffirmations();
      await service.deleteCustomAffirmation(customs.first.id);
      expect(service.getCustomAffirmations(), isEmpty);
    });

    test('getAiSuggestions returns suggestions', () {
      final suggestions = service.getAiSuggestions('');
      expect(suggestions, isNotEmpty);
      expect(suggestions.length, 10);
    });

    test('getAiSuggestions filters by prefix', () {
      final suggestions = service.getAiSuggestions('worthy');
      expect(suggestions, isNotEmpty);
      for (final s in suggestions) {
        expect(s.toLowerCase(), contains('worthy'));
      }
    });

    test('multiple saves accumulate', () async {
      await service.saveCustomAffirmation('First');
      await service.saveCustomAffirmation('Second');
      await service.saveCustomAffirmation('Third');
      expect(service.getCustomAffirmations().length, 3);
    });
  });
}
