import 'package:swiss_ai/data/chat/model/chat_message.dart';
import 'package:swiss_ai/data/local/objectbox/app_objectbox.dart';
import 'package:swiss_ai/data/local/objectbox/objectbox_entities.dart';
import 'package:swiss_ai/objectbox.g.dart';

/// Local persistence for chat sessions.
///
/// The in-memory store is the source of truth; when an [AppObjectBox] is
/// supplied, messages are mirrored to ObjectBox and hydrated on startup for
/// durable persistence. Without one (web, tests) it is a pure-Dart store.
class ChatDbService {
  final AppObjectBox? _ob;
  final List<ChatMessage> _store = [];

  ChatDbService({AppObjectBox? objectBox}) : _ob = objectBox {
    final ob = _ob;
    if (ob != null) {
      for (final entity in ob.messages.query().build().find()) {
        _store.add(_toModel(entity));
      }
    }
  }

  Future<List<ChatMessage>> getMessages() async {
    return List.unmodifiable(_store);
  }

  Stream<List<ChatMessage>> messages() async* {
    yield List.unmodifiable(_store);
  }

  Future<void> saveMessage(ChatMessage message) async {
    _store.add(message);
    final ob = _ob;
    if (ob == null) return;
    ob.messages.put(ChatMessageEntity(
      uid: message.id,
      role: _ordinal(message.role),
      content: message.content,
    ));
  }

  Future<void> clear() async {
    _store.clear();
    _ob?.messages.removeAll();
  }

  static int _ordinal(ChatRole role) => switch (role) {
        ChatRole.system => ChatRoleOrdinal.system,
        ChatRole.user => ChatRoleOrdinal.user,
        ChatRole.assistant => ChatRoleOrdinal.assistant,
        ChatRole.tool => ChatRoleOrdinal.tool,
      };

  static ChatMessage _toModel(ChatMessageEntity e) => ChatMessage(
        id: e.uid,
        role: switch (e.role) {
          ChatRoleOrdinal.user => ChatRole.user,
          ChatRoleOrdinal.assistant => ChatRole.assistant,
          ChatRoleOrdinal.tool => ChatRole.tool,
          _ => ChatRole.system,
        },
        content: e.content,
      );
}
