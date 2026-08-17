import 'package:swiss_ai/data/local/objectbox/app_objectbox.dart';
import 'package:swiss_ai/data/personas/model/persona.dart';

/// Local persistence for the selectable assistant personas.
///
/// The persona catalog is a static seed (shipped with the app); only the
/// selected persona id is mutable. When an [AppObjectBox] is supplied the
/// selection is persisted to ObjectBox and restored on startup; otherwise
/// (web, tests) it lives only in memory.
class PersonasDbService {
  final AppObjectBox? _ob;

  /// The default set of assistant personas shipped with the app.
  static const List<Persona> _seed = [
    Persona(
      id: 'expert',
      name: 'Expert',
      description: 'Deep, thorough answers to complex problems.',
      systemPrompt:
          'You are an expert assistant. Provide detailed, technically '
          'precise, step-by-step answers.',
      iconName: 'science',
    ),
    Persona(
      id: 'concise',
      name: 'Concise',
      description: 'Short, direct, no-filler answers.',
      systemPrompt:
          'You are a concise assistant. Reply in as few words as possible '
          'while staying accurate.',
      iconName: 'bolt',
    ),
    Persona(
      id: 'friendly',
      name: 'Friendly',
      description: 'Warm, upbeat and encouraging tone.',
      systemPrompt:
          'You are a friendly assistant. Use a warm, encouraging and '
          'approachable tone.',
      iconName: 'mood',
    ),
    Persona(
      id: 'teacher',
      name: 'Teacher',
      description: 'Explains concepts patiently like a tutor.',
      systemPrompt:
          'You are a patient teacher. Explain concepts clearly with examples '
          'suited to a learner.',
      iconName: 'school',
    ),
  ];

  String? _selectedId;

  PersonasDbService({AppObjectBox? objectBox}) : _ob = objectBox {
    _selectedId = objectBox?.selectedPersona;
  }

  Future<List<Persona>> getAll() async {
    return List.unmodifiable(_seed);
  }

  Future<String?> getSelectedId() async => _selectedId;

  Future<void> select(String id) async {
    _selectedId = id;
    _ob?.setSelectedPersona(id);
  }

  Future<void> clearSelection() async {
    _selectedId = null;
    _ob?.setSelectedPersona(null);
  }
}
