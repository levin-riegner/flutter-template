import 'package:bloc_test/bloc_test.dart';
import 'package:swiss_ai/data/study/model/flashcard.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/presentation/study/bloc/study_bloc.dart';
import 'package:swiss_ai/presentation/study/bloc/study_error.dart';
import 'package:swiss_ai/presentation/study/bloc/study_event.dart';
import 'package:swiss_ai/presentation/study/bloc/study_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements StudyRepository {}

void main() {
  group('StudyBloc', () {
    late _MockRepository mockRepository;
    // Non-const because Flashcard carries a DateTime.
    final cards = [
      Flashcard(
        id: '1',
        front: 'Front 1',
        back: 'Back 1',
        deckName: 'Flutter Basics',
        dueAt: DateTime(2026, 1, 1),
        repetitions: 0,
      ),
      Flashcard(
        id: '2',
        front: 'Front 2',
        back: 'Back 2',
        deckName: 'Flutter Basics',
        dueAt: DateTime(2026, 1, 1),
        repetitions: 0,
      ),
    ];

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    group('StudyEvent.openDeck', () {
      blocTest<StudyBloc, StudyState>(
        'should emit loading then success with deck cards',
        setUp: () => when(() => mockRepository.getDeck(any()))
            .thenAnswer((_) async => cards),
        build: () => StudyBloc(mockRepository),
        act: (bloc) => bloc.add(
            const StudyEvent.openDeck(deckName: 'Flutter Basics')),
        expect: () => [
          const StudyState.studying(
              data: DataState.loading(), isFlipped: false, index: 0),
          StudyState.studying(
              data: DataState.success(data: cards),
              isFlipped: false,
              index: 0),
        ],
      );

      blocTest<StudyBloc, StudyState>(
        'should emit failure when loading throws',
        setUp: () => when(() => mockRepository.getDeck(any()))
            .thenThrow(Exception('boom')),
        build: () => StudyBloc(mockRepository),
        act: (bloc) => bloc.add(
            const StudyEvent.openDeck(deckName: 'Flutter Basics')),
        skip: 1,
        expect: () => [
          StudyState.studying(
              data: DataState.failure(
                  reason: StudyError.unknown(reason: 'Exception: boom')),
              isFlipped: false,
              index: 0),
        ],
      );
    });

    group('StudyEvent.flip', () {
      blocTest<StudyBloc, StudyState>(
        'should toggle isFlipped',
        setUp: () {
          when(() => mockRepository.getDeck(any()))
              .thenAnswer((_) async => cards);
        },
        build: () => StudyBloc(mockRepository),
        act: (bloc) {
          bloc.add(const StudyEvent.openDeck(deckName: 'Flutter Basics'));
          bloc.add(const StudyEvent.flip());
        },
        skip: 2,
        expect: () => [
          StudyState.studying(
              data: DataState.success(data: cards),
              isFlipped: true,
              index: 0),
        ],
      );

      blocTest<StudyBloc, StudyState>(
        'should flip back to front on a second flip',
        setUp: () {
          when(() => mockRepository.getDeck(any()))
              .thenAnswer((_) async => cards);
        },
        build: () => StudyBloc(mockRepository),
        act: (bloc) {
          bloc.add(const StudyEvent.openDeck(deckName: 'Flutter Basics'));
          bloc.add(const StudyEvent.flip());
          bloc.add(const StudyEvent.flip());
        },
        skip: 3,
        expect: () => [
          StudyState.studying(
              data: DataState.success(data: cards),
              isFlipped: false,
              index: 0),
        ],
      );
    });

    group('StudyEvent.answer', () {
      blocTest<StudyBloc, StudyState>(
        'should answer the current card and advance the index',
        setUp: () {
          when(() => mockRepository.getDeck(any()))
              .thenAnswer((_) async => cards);
          when(() => mockRepository.answerCard(
                id: any(named: 'id'),
                correct: any(named: 'correct'),
              ))
              .thenAnswer((_) async => cards[0]);
        },
        build: () => StudyBloc(mockRepository),
        act: (bloc) {
          bloc.add(const StudyEvent.openDeck(deckName: 'Flutter Basics'));
          bloc.add(const StudyEvent.answer(correct: true));
        },
        skip: 2,
        expect: () => [
          StudyState.studying(
              data: DataState.success(data: cards),
              isFlipped: false,
              index: 1),
        ],
      );

      blocTest<StudyBloc, StudyState>(
        'should not advance past the last card',
        setUp: () {
          when(() => mockRepository.getDeck(any()))
              .thenAnswer((_) async => cards);
          when(() => mockRepository.answerCard(
                id: any(named: 'id'),
                correct: any(named: 'correct'),
              ))
              .thenAnswer((_) async => cards[1]);
        },
        build: () => StudyBloc(mockRepository),
        act: (bloc) {
          bloc.add(const StudyEvent.openDeck(deckName: 'Flutter Basics'));
          bloc.add(const StudyEvent.answer(correct: true));
          bloc.add(const StudyEvent.answer(correct: false));
        },
        // The 4th emit would be identical to the 3rd (index 1 again), so the
        // bloc deduplicates it — which is exactly how it proves we don't advance
        // past the last card. Skip the loading + success + first answer states.
        skip: 2,
        expect: () => [
          StudyState.studying(
              data: DataState.success(data: cards),
              isFlipped: false,
              index: 1),
        ],
      );
    });
  });
}
