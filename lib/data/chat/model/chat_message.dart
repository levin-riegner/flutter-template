import 'package:equatable/equatable.dart';

enum ChatRole { system, user, assistant, tool }

/// A single message in an on-device AI chat session.
///
/// Kept as a plain immutable model so the chat feature stays testable on the
/// host without native plugins (same convention as the article feature).
class ChatMessage extends Equatable {
  final String id;
  final ChatRole role;
  final String content;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
  });

  bool get isUser => role == ChatRole.user;

  @override
  List<Object?> get props => [id, role, content];
}
