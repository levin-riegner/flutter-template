import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/data/personas/service/local/personas_db_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('PersonalitiesRepository', () {
    final dbService = PersonasDbService();
    final repository = PersonalitiesRepository(dbService);
    setUp(() {
      dbService.clearSelection();
    });

    test('getAll returns the four seeded default personas', () async {
      final personas = await repository.getAll();
      assert(personas.length == 4);
      assert(personas.map((p) => p.name).toSet().containsAll(
          ['Expert', 'Concise', 'Friendly', 'Teacher']));
    });

    test('getSelectedId is null before any selection', () async {
      assert(await repository.getSelectedId() == null);
    });

    test('select persists the active persona id', () async {
      await repository.select('teacher');
      assert(await repository.getSelectedId() == 'teacher');

      await repository.select('concise');
      assert(await repository.getSelectedId() == 'concise');
    });
  });
}
