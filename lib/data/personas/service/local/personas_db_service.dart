import 'package:swiss_ai/data/personas/model/persona.dart';

/// Local persistence for the selectable assistant personas.
///
/// Pure-Dart in-memory store (same convention as ChatDbService) so the
/// personas feature stays testable on the host without native plugins.
class PersonasDbService {
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

  Future<List<Persona>> getAll() async {
    return List.unmodifiable(_seed);
  }

  Future<String?> getSelectedId() async => _selectedId;

  Future<void> select(String id) async {
    _selectedId = id;
  }

  Future<void> clearSelection() async {
    _selectedId = null;
  }
}
