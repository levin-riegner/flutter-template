import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/service/local/chat_db_service.dart';
import 'package:color_picker/data/image_gen/model/generated_image.dart';
import 'package:color_picker/data/image_gen/service/local/image_gen_db_service.dart';
import 'package:color_picker/data/recording/model/recording.dart';
import 'package:color_picker/data/recording/service/local/recording_db_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../integration_test_shared.dart';

// Integration tests for the on-device AI local stores (pure-Dart in-memory).
void main() async {
  ensureInitialized();

  group("Chat DB Service", () {
    late ChatDbService dbService;
    setUp(() async {
      dbService = ChatDbService();
    });

    testWidgets('should persist and return chat messages', (tester) async {
      await dbService.saveMessage(
        const ChatMessage(id: '1', role: ChatRole.user, content: 'Hello'),
      );
      await dbService.saveMessage(
        const ChatMessage(id: '2', role: ChatRole.assistant, content: 'Hi!'),
      );
      final messages = await dbService.getMessages();
      assert(messages.length == 2);
      assert(messages.first.content == 'Hello');
    });

    testWidgets('should clear messages', (tester) async {
      await dbService.saveMessage(
        const ChatMessage(id: '1', role: ChatRole.user, content: 'Hello'),
      );
      await dbService.clear();
      final messages = await dbService.getMessages();
      assert(messages.isEmpty);
    });
  });

  group("ImageGen DB Service", () {
    late ImageGenDbService dbService;
    setUp(() async {
      dbService = ImageGenDbService();
    });

    testWidgets('should persist and return generated images', (tester) async {
      await dbService.saveImage(
        const GeneratedImage(id: '1', prompt: 'A mountain lake'),
      );
      final images = await dbService.getImages();
      assert(images.length == 1);
      assert(images.first.prompt == 'A mountain lake');
    });
  });

  group("Recording DB Service", () {
    late RecordingDbService dbService;
    setUp(() async {
      dbService = RecordingDbService();
    });

    testWidgets('should persist and return recordings', (tester) async {
      await dbService.saveRecording(
        Recording(
          id: '1',
          title: 'Sprint sync',
          transcript: 'Discussed roadmap',
          capturedAt: DateTime(2026, 8, 12),
        ),
      );
      final recordings = await dbService.getRecordings();
      assert(recordings.length == 1);
      assert(recordings.first.title == 'Sprint sync');
    });
  });
}
