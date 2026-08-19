import 'package:equatable/equatable.dart';

/// A selectable AI assistant persona used to shape chat behaviour.
///
/// Kept as a plain immutable model so the personas feature stays testable on
/// the host without native plugins (same convention as the chat model).
class Persona extends Equatable {
  final String id;
  final String name;
  final String description;
  final String systemPrompt;
  final String iconName;

  const Persona({
    required this.id,
    required this.name,
    required this.description,
    required this.systemPrompt,
    required this.iconName,
  });

  @override
  List<Object?> get props => [id, name, description, systemPrompt, iconName];
}
