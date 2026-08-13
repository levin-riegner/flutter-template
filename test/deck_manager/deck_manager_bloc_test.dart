import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/study/model/deck.dart';
import 'package:color_picker/data/study/repository/study_repository.dart';
import 'package:color_picker/presentation/deck_manager/bloc/deck_manager_bloc.dart';
import 'package:color_picker/presentation/deck_manager/bloc/deck_manager_error.dart';
import 'package:color_picker/presentation/deck_manager/bloc/deck_manager_event.dart';
import 'package:color_picker/presentation/deck_manager/bloc/deck_manager_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements StudyRepository {}

void main() {
  group('DeckManagerBloc', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    blocTest<DeckManagerBloc, DeckManagerState>(
      'load emits the deck list',
      setUp: () {
        when(() => mockRepository.getDecks()).thenAnswer((_) async => [
          const Deck(name: 'Flutter Basics', newCount: 2, dueCount: 1),
        ]);
      },
      build: () => DeckManagerBloc(mockRepository),
      act: (bloc) => bloc.add(const DeckManagerEvent.load()),
      expect: () => [
        const DeckManagerState.management(
          decks: DataState.success(data: [
            Deck(name: 'Flutter Basics', newCount: 2, dueCount: 1),
          ]),
          openDeckName: null,
          cards: DataState.idle(),
        ),
      ],
    );

    blocTest<DeckManagerBloc, DeckManagerState>(
      'opening a deck loads its cards',
      setUp: () {
        when(() => mockRepository.getDecks()).thenAnswer((_) async => [
          const Deck(name: 'Flutter Basics', newCount: 1, dueCount: 0),
        ]);
        when(() => mockRepository.getDeck(any())).thenAnswer((_) async => []);
      },
      build: () => DeckManagerBloc(mockRepository),
      // Load first so the deck list exists, then open the deck.
      seed: () {
        // (seed not used) no-op
        return const DeckManagerState.management(
          decks: DataState.success(data: [
            Deck(name: 'Flutter Basics', newCount: 1, dueCount: 0),
          ]),
          openDeckName: null,
          cards: DataState.idle(),
        );
      },
      act: (bloc) => bloc.add(const DeckManagerEvent.openDeck(name: 'Flutter Basics')),
      expect: () => [
        const DeckManagerState.management(
          decks: DataState.success(data: [
            Deck(name: 'Flutter Basics', newCount: 1, dueCount: 0),
          ]),
          openDeckName: 'Flutter Basics',
          cards: DataState.loading(),
        ),
        const DeckManagerState.management(
          decks: DataState.success(data: [
            Deck(name: 'Flutter Basics', newCount: 1, dueCount: 0),
          ]),
          openDeckName: 'Flutter Basics',
          cards: DataState.success(data: []),
        ),
      ],
    );

    blocTest<DeckManagerBloc, DeckManagerState>(
      'creating a deck with an empty name emits emptyName failure',
      build: () => DeckManagerBloc(mockRepository),
      act: (bloc) => bloc.add(const DeckManagerEvent.createDeck(name: '   ')),
      expect: () => [
        const DeckManagerState.management(
          decks: DataState.idle(),
          openDeckName: null,
          cards: DataState.failure(reason: DeckManagerError.emptyName()),
        ),
      ],
    );
  });
}
