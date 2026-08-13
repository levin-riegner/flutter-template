import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/data/personas/model/persona.dart';
import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:color_picker/data/study/repository/study_repository.dart';
import 'package:color_picker/data/study_tutor/repository/study_tutor_repository.dart';
import 'package:test/scaffolding.dart';
import 'package:mocktail/mocktail.dart';

class _MockStudy extends Mock implements StudyRepository {}

class _MockPersonas extends Mock implements PersonalitiesRepository {}

class _MockChat extends Mock implements ChatRepository {}

void main() {
  const teacher = Persona(
    id: 'teacher',
    name: 'Teacher',
    description: 'Explains clearly',
    systemPrompt: 'You are a patient teacher.',
    iconName: 'school',
  );
  final cards = [
    Flashcard(
      id: 'f1',
      front: 'What is a widget?',
      back: 'A widget is a UI element.',
      deckName: 'Flutter Basics',
      dueAt: DateTime(2026, 1, 1),
      repetitions: 0,
    ),
  ];

  group('StudyTutorRepository', () {
    late _MockStudy mockStudy;
    late _MockPersonas mockPersonas;
    late _MockChat mockChat;
    late StudyTutorRepository repository;

    setUp(() {
      mockStudy = _MockStudy();
      mockPersonas = _MockPersonas();
      mockChat = _MockChat();
      reset(mockStudy);
      reset(mockPersonas);
      reset(mockChat);
      repository = StudyTutorRepository(mockStudy, mockPersonas, mockChat);
    });

    test('startTutorSession builds a deck prompt and returns the welcome',
        () async {
      when(() => mockStudy.getDeck(any())).thenAnswer((_) async => cards);
      when(() => mockPersonas.getSelectedId()).thenAnswer((_) async => null);
      when(() => mockChat.sendMessage(any(), systemPrompt: any(named: 'systemPrompt')))
          .thenAnswer((_) async => [
        const ChatMessage(id: 'a1', role: ChatRole.assistant, content: 'Ready'),
      ]);

      final session = await repository.startTutorSession('Flutter Basics');
      assert(session.deckName == 'Flutter Basics');
      assert(session.cards.length == 1);
      assert(session.welcome == 'Ready');
      assert(session.personaId == null);
    });

    test('passes the active persona system prompt when one is selected',
        () async {
      when(() => mockStudy.getDeck(any())).thenAnswer((_) async => cards);
      when(() => mockPersonas.getSelectedId()).thenAnswer((_) async => 'teacher');
      when(() => mockPersonas.getAll()).thenAnswer((_) async => [teacher]);
      when(() => mockChat.sendMessage(any(), systemPrompt: any(named: 'systemPrompt')))
          .thenAnswer((_) async => []);

      await repository.startTutorSession('Flutter Basics');
      assert(repository.lastSystemPrompt == teacher.systemPrompt);
    });

    test('ask forwards a follow-up question to chat', () async {
      when(() => mockPersonas.getSelectedId()).thenAnswer((_) async => null);
      when(() => mockChat.sendMessage(any(), systemPrompt: any(named: 'systemPrompt')))
          .thenAnswer((_) async => [
        const ChatMessage(
            id: 'a1', role: ChatRole.assistant, content: 'A widget renders UI.'),
      ]);
      final messages = await repository.ask('What is a widget?');
      assert(messages.length == 1);
      assert(messages.first.content == 'A widget renders UI.');
    });
  });
}
