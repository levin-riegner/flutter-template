import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiss_ai/data/chat/model/chat_message.dart';
import 'package:swiss_ai/data/chat/repository/chat_repository.dart';
import 'package:swiss_ai/data/quiz/model/quiz_item.dart';
import 'package:swiss_ai/data/quiz/repository/quiz_repository.dart';
import 'package:swiss_ai/data/study/model/flashcard.dart';
import 'package:swiss_ai/data/study/model/deck.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';

class _MockChatRepository extends Mock implements ChatRepository {}

class _MockStudyRepository extends Mock implements StudyRepository {}

const _assistantJson =
    '\n[{"front":"Q1","back":"A1"},{"front":"Q2","back":"A2"}]';

void main() {
  late _MockChatRepository chatRepo;
  late _MockStudyRepository studyRepo;
  late QuizRepository repository;

  setUp(() {
    chatRepo = _MockChatRepository();
    studyRepo = _MockStudyRepository();
    repository = QuizRepository(chatRepo, studyRepo);
    registerFallbackValue(Flashcard(
      id: 'x',
      front: 'f',
      back: 'b',
      deckName: 'd',
      dueAt: DateTime(2026),
      repetitions: 0,
    ));
  });

  Future<List<ChatMessage>> _history() async => [
        ChatMessage(id: '1', role: ChatRole.user, content: 'prompt'),
        ChatMessage(
            id: '2', role: ChatRole.assistant, content: _assistantJson),
      ];

  test('generates quiz items from the assistant reply', () async {
    when(
        () => chatRepo.sendMessage(
            any(),
            systemPrompt: any(named: 'systemPrompt'),
            disableThinking: any(named: 'disableThinking')))
        .thenAnswer((_) async => _history());

    final items =
        await repository.generateFromDocument('some document text');

    expect(items, hasLength(2));
    expect(items, everyElement(isA<QuizItem>()));
    expect(items.first.front, 'Q1');

    final captured = verify(() => chatRepo.sendMessage(captureAny(),
        systemPrompt: any(named: 'systemPrompt'),
        disableThinking: true)).captured.single as String;
    expect(captured, contains('some document text'));
  });

  test('rejects an empty document', () async {
    expect(
        () => repository.generateFromDocument('   '),
        throwsFormatException);
  });

  test('saves items as a new study deck', () async {
    when(() => studyRepo.createDeck(any()))
        .thenAnswer((_) async =>
            const Deck(name: 'My Quiz', newCount: 2, dueCount: 2));
    when(() => studyRepo.addCard(
        deckName: any(named: 'deckName'),
        front: any(named: 'front'),
        back: any(named: 'back'))).thenAnswer((_) async => Flashcard(
          id: 'new',
          front: 'f',
          back: 'b',
          deckName: 'd',
          dueAt: DateTime(2026),
          repetitions: 0,
        ));

    final count = await repository.saveAsDeck(
      const [
        QuizItem(front: 'Q1', back: 'A1'),
        QuizItem(front: 'Q2', back: 'A2'),
      ],
      'My Quiz',
    );

    expect(count, 2);
    verify(() => studyRepo.createDeck('My Quiz')).called(1);
    verify(() => studyRepo.addCard(
        deckName: 'My Quiz', front: 'Q1', back: 'A1')).called(1);
    verify(() => studyRepo.addCard(
        deckName: 'My Quiz', front: 'Q2', back: 'A2')).called(1);
  });

  test('saveAsDeck rejects an empty list', () async {
    expect(() => repository.saveAsDeck([], 'd'), throwsFormatException);
  });
}
