import 'package:equatable/equatable.dart';

/// One quiz question generated from a document.
///
/// [front] is the question, [back] is the expected answer. The shape mirrors
/// [Flashcard] (front/back) so quiz items can be saved straight into a study
/// deck.
class QuizItem extends Equatable {
  final String front;
  final String back;

  const QuizItem({required this.front, required this.back});

  @override
  List<Object?> get props => [front, back];
}
