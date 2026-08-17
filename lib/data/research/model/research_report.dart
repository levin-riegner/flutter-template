import 'package:equatable/equatable.dart';

/// One gathered fact with its origin.
class ResearchNote extends Equatable {
  final String fact;
  final String sourceUrl;

  const ResearchNote({required this.fact, required this.sourceUrl});

  @override
  List<Object?> get props => [fact, sourceUrl];
}

/// A deep-research report: the question, the sub-questions explored,
/// gathered sourced notes, and the model's synthesis.
class ResearchReport extends Equatable {
  final String question;
  final List<String> subquestions;
  final List<ResearchNote> notes;
  final String summary;

  const ResearchReport({
    required this.question,
    required this.subquestions,
    required this.notes,
    required this.summary,
  });

  /// Number of distinct source documents consulted.
  int get distinctSourceCount =>
      notes.map((n) => n.sourceUrl).toSet().length;

  @override
  List<Object?> get props => [question, subquestions, notes, summary];
}
