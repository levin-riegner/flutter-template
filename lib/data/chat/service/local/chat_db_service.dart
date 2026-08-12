import 'package:color_picker/data/chat/model/chat_message.dart';

/// Local persistence for chat sessions.
///
/// Pure-Dart in-memory store (same convention as ArticleDbService) so the chat
/// feature is testable on the host without native plugins. Production could
/// swap the backing store for drift/sqlite behind this same interface.
class ChatDbService {
  final List<ChatMessage> _store = [];

  Future<List<ChatMessage>> getMessages() async {
    return List.unmodifiable(_store);
  }

  Stream<List<ChatMessage>> messages() async* {
    yield List.unmodifiable(_store);
  }

  Future<void> saveMessage(ChatMessage message) async {
    _store.add(message);
  }

  Future<void> clear() async {
    _store.clear();
  }
}
