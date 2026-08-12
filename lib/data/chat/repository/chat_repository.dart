import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/service/local/chat_db_service.dart';
import 'package:color_picker/data/chat/service/remote/chat_api_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ChatRepository {
  final ChatApiService _apiService;
  final ChatDbService _dbService;
  int _idCounter = 0;

  ChatRepository(
    this._apiService,
    this._dbService,
  );

  Future<List<ChatMessage>> getMessages() async {
    return _dbService.getMessages();
  }

  /// Sends a user message, appends both sides to the local store and
  /// returns the full conversation history.
  Future<List<ChatMessage>> sendMessage(String content) async {
    Flogger.i("Sending chat message");
    final userMessage = ChatMessage(
      id: '${_idCounter++}',
      role: ChatRole.user,
      content: content,
    );
    await _dbService.saveMessage(userMessage);

    final history = await _dbService.getMessages();
    final payload = history
        .map((m) => {'role': m.role.name, 'content': m.content})
        .toList();

    final reply = await _apiService.sendChat(payload);

    final assistantMessage = ChatMessage(
      id: '${_idCounter++}',
      role: ChatRole.assistant,
      content: reply,
    );
    await _dbService.saveMessage(assistantMessage);
    return _dbService.getMessages();
  }

  Future<void> clear() async {
    await _dbService.clear();
  }
}
