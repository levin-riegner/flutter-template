import 'package:color_picker/data/personas/model/persona.dart';
import 'package:color_picker/data/personas/service/local/personas_db_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Provides the selectable assistant personas and tracks the active selection.
class PersonalitiesRepository {
  final PersonasDbService _dbService;

  PersonalitiesRepository(this._dbService);

  /// Returns all available assistant personas.
  Future<List<Persona>> getAll() async {
    return _dbService.getAll();
  }

  /// The id of the currently selected persona, if any.
  Future<String?> getSelectedId() async {
    return _dbService.getSelectedId();
  }

  /// Persists the given persona id as the active selection.
  Future<void> select(String id) async {
    Flogger.i("Selected assistant persona: $id");
    await _dbService.select(id);
  }
}
