import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/data/chat/service/local/chat_db_service.dart';
import 'package:color_picker/data/chat/service/remote/chat_api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _MockApiService extends Mock implements ChatApiService {}

void main() {
  group("ChatRepository", () {
    final dbService = ChatDbService();
    final apiService = _MockApiService();
    final chatRepository = ChatRepository(apiService, dbService);
    setUp(() {
      reset(apiService);
      dbService.clear();
    });

    test("should append user and assistant messages on send", () async {
      when(() => apiService.sendChat(any())).thenAnswer((_) async => "Hello!");
      final messages = await chatRepository.sendMessage("Hi");
      assert(messages.length == 2);
      assert(messages[0].role == ChatRole.user);
      assert(messages[0].content == "Hi");
      assert(messages[1].role == ChatRole.assistant);
      assert(messages[1].content == "Hello!");
    });

    test("should include user message in payload sent to api", () async {
      when(() => apiService.sendChat(any())).thenAnswer((_) async => "Reply");
      await chatRepository.sendMessage("Question");
      verify(() => apiService.sendChat(any(that: hasLength(1)))).called(1);
    });
  });
}
