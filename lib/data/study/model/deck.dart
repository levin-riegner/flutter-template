import 'package:equatable/equatable.dart';

/// A group of flashcards sharing a [name].
///
/// [newCount] is the number of cards never reviewed and [dueCount] is the
/// number of cards currently due for review, giving the user a quick view of
/// how much study is outstanding per deck.
class Deck extends Equatable {
  final String name;
  final int newCount;
  final int dueCount;

  const Deck({
    required this.name,
    required this.newCount,
    required this.dueCount,
  });

  @override
  List<Object?> get props => [name, newCount, dueCount];
}
