import 'package:color_picker/data/article/service/local/model/article_db_model.dart';
import 'package:isar/isar.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Articles])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  static AppDatabase init({required String directory}) {
    return AppDatabase(
      driftDatabase(
        name: 'app_database',
        native: DriftNativeOptions(
          databaseDirectory: () async => directory,
        ),
      ),
    );
  }

  // FNV-1a 64bit hash algorithm optimized for Dart Strings
  static int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
