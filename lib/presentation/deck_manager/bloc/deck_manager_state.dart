import 'package:color_picker/data/study/model/deck.dart';
import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:color_picker/presentation/deck_manager/bloc/deck_manager_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_manager_state.freezed.dart';

@freezed
sealed class DeckManagerState with _$DeckManagerState {
  const factory DeckManagerState.management({
    required DataState<List<Deck>, DeckManagerError> decks,
    required String? openDeckName,
    required DataState<List<Flashcard>, DeckManagerError> cards,
  }) = _Management;
}
