import 'package:bloc_test/bloc_test.dart';
import 'package:swiss_ai/data/chat/model/chat_message.dart';
import 'package:swiss_ai/data/chat/repository/chat_repository.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_bloc.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_error.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_event.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ChatRepository {}

void main() {
  group('ChatBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
      when(() => mockRepository.getMessages()).thenAnswer((_) async => []);
    });
    group("ChatEvent.sendMessage", () {
      const userMessage = ChatMessage(
        id: "0",
        role: ChatRole.user,
        content: "Hi",
      );
      const assistantMessage = ChatMessage(
        id: "1",
        role: ChatRole.assistant,
        content: "Hello!",
      );
      blocTest<ChatBloc, ChatState>(
        'should emit sending state then success with messages',
        setUp: () => when(() => mockRepository.sendMessage(any()))
            .thenAnswer((_) async => [userMessage, assistantMessage]),
        build: () => ChatBloc(mockRepository),
        act: (bloc) => bloc.add(const ChatEvent.sendMessage(content: "Hi")),
        expect: () => [
          const ChatState.chat(
              data: DataState.success(data: []), isSending: true),
          const ChatState.chat(
              data:
                  DataState.success(data: [userMessage, assistantMessage]),
              isSending: false),
        ],
      );
      blocTest<ChatBloc, ChatState>(
        'should emit failure when sending throws',
        setUp: () => when(() => mockRepository.sendMessage(any()))
            .thenThrow(Exception("boom")),
        build: () => ChatBloc(mockRepository),
        act: (bloc) => bloc.add(const ChatEvent.sendMessage(content: "Hi")),
        skip: 1,
        expect: () => [
          ChatState.chat(
              data: DataState.failure(
                  reason: ChatError.unknown(reason: "Exception: boom")),
              isSending: false),
        ],
      );
    });

    group("ChatEvent.clear", () {
      blocTest<ChatBloc, ChatState>(
        'should clear messages',
        setUp: () => when(() => mockRepository.clear())
            .thenAnswer((_) async {}),
        build: () => ChatBloc(mockRepository),
        act: (bloc) => bloc.add(const ChatEvent.clear()),
        expect: () => [
          const ChatState.chat(
              data: DataState.success(data: []), isSending: false),
        ],
      );
    });
  });
}
