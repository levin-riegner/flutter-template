import 'package:swiss_ai/data/study/model/deck.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/presentation/deck_manager/bloc/deck_manager_error.dart';
import 'package:swiss_ai/presentation/deck_manager/bloc/deck_manager_event.dart';
import 'package:swiss_ai/presentation/deck_manager/bloc/deck_manager_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class DeckManagerBloc extends Bloc<DeckManagerEvent, DeckManagerState> {
  final StudyRepository _repository;

  DeckManagerBloc(this._repository)
      : super(const DeckManagerState.management(
          decks: DataState.idle(),
          openDeckName: null,
          cards: DataState.idle(),
        )) {
    on<DeckManagerEvent>((event, emit) async {
      await event.when(
        load: () => _load(emit),
        openDeck: (name) => _openDeck(emit, name),
        createDeck: (name) => _createDeck(emit, name),
        addCard: (front, back) => _addCard(emit, front, back),
        removeCard: (id) => _removeCard(emit, id),
        deleteDeck: (name) => _deleteDeck(emit, name),
      );
    });
  }

  Future<void> _load(Emitter<DeckManagerState> emit) async {
    try {
      final decks = await _repository.getDecks();
      emit(DeckManagerState.management(
        decks: DataState.success(data: decks),
        openDeckName: state.openDeckName,
        cards: state.cards,
      ));
    } catch (e) {
      Flogger.w("Failed to load decks: $e");
      emit(DeckManagerState.management(
        decks: DataState.failure(
          reason: DeckManagerError.unknown(reason: e.toString()),
        ),
        openDeckName: null,
        cards: const DataState.idle(),
      ));
    }
  }

  Future<void> _openDeck(Emitter<DeckManagerState> emit, String name) async {
    final decks = state.decksData;
    if (!decks.any((d) => d.name == name)) {
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: null,
        cards: DataState.failure(
          reason: DeckManagerError.unknown(reason: 'Unknown deck $name'),
        ),
      ));
      return;
    }
    emit(DeckManagerState.management(
      decks: state.decks,
      openDeckName: name,
      cards: DataState.loading(),
    ));
    try {
      final cards = await _repository.getDeck(name);
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: name,
        cards: DataState.success(data: cards),
      ));
    } catch (e) {
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: name,
        cards: DataState.failure(
          reason: DeckManagerError.unknown(reason: e.toString()),
        ),
      ));
    }
  }

  Future<void> _createDeck(Emitter<DeckManagerState> emit, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: state.openDeckName,
        cards: DataState.failure(reason: DeckManagerError.emptyName()),
      ));
      return;
    }
    if (state.decksData.any((d) => d.name == trimmed)) {
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: state.openDeckName,
        cards: DataState.failure(reason: DeckManagerError.duplicate()),
      ));
      return;
    }
    try {
      await _repository.createDeck(trimmed);
      final decks = await _repository.getDecks();
      emit(DeckManagerState.management(
        decks: DataState.success(data: decks),
        openDeckName: state.openDeckName,
        cards: state.cards,
      ));
    } catch (e) {
      emit(DeckManagerState.management(
        decks: DataState.failure(
          reason: DeckManagerError.unknown(reason: e.toString()),
        ),
        openDeckName: null,
        cards: const DataState.idle(),
      ));
    }
  }

  Future<void> _addCard(
    Emitter<DeckManagerState> emit,
    String front,
    String back,
  ) async {
    final deckName = state.openDeckName;
    if (deckName == null || front.trim().isEmpty || back.trim().isEmpty) {
      return;
    }
    try {
      await _repository.addCard(
        deckName: deckName,
        front: front.trim(),
        back: back.trim(),
      );
      final cards = await _repository.getDeck(deckName);
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: deckName,
        cards: DataState.success(data: cards),
      ));
    } catch (e) {
      emit(DeckManagerState.management(
        decks: state.decks,
        openDeckName: deckName,
        cards: DataState.failure(
          reason: DeckManagerError.unknown(reason: e.toString()),
        ),
      ));
    }
  }

  Future<void> _removeCard(Emitter<DeckManagerState> emit, String id) async {
    final deckName = state.openDeckName;
    if (deckName == null) {
      return;
    }
    await _repository.removeCard(id);
    final cards = await _repository.getDeck(deckName);
    emit(DeckManagerState.management(
      decks: state.decks,
      openDeckName: deckName,
      cards: DataState.success(data: cards),
    ));
  }

  Future<void> _deleteDeck(Emitter<DeckManagerState> emit, String name) async {
    await _repository.deleteDeck(name);
    final decks = await _repository.getDecks();
    emit(DeckManagerState.management(
      decks: DataState.success(data: decks),
      openDeckName: null,
      cards: const DataState.idle(),
    ));
  }
}

extension on DeckManagerState {
  List<Deck> get decksData => switch (decks) {
        Success(data: final data) => data,
        _ => const [],
      };
}
