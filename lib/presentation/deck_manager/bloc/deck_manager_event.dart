import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_manager_event.freezed.dart';

@freezed
sealed class DeckManagerEvent with _$DeckManagerEvent {
  const factory DeckManagerEvent.load() = DeckManagerEventLoad;

  const factory DeckManagerEvent.openDeck({required String name}) =
      DeckManagerEventOpenDeck;

  const factory DeckManagerEvent.createDeck({required String name}) =
      DeckManagerEventCreateDeck;

  const factory DeckManagerEvent.addCard({
    required String front,
    required String back,
  }) = DeckManagerEventAddCard;

  const factory DeckManagerEvent.removeCard({required String id}) =
      DeckManagerEventRemoveCard;

  const factory DeckManagerEvent.deleteDeck({required String name}) =
      DeckManagerEventDeleteDeck;
}
