import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/data/shared/model/error/data_error.dart';
import 'package:color_picker/presentation/chat/bloc/chat_error.dart';
import 'package:color_picker/presentation/chat/bloc/chat_event.dart';
import 'package:color_picker/presentation/chat/bloc/chat_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc(this._chatRepository)
      : super(const ChatState.chat(
          data: DataState.success(data: []),
          isSending: false,
        )) {
    on<ChatEvent>((event, emit) async {
      await event.when(
        sendMessage: (content) => _sendMessage(emit, content),
        clear: () => _clear(emit),
      );
    });
  }

  Future<void> _sendMessage(
    Emitter<ChatState> emit,
    String content,
  ) async {
    final List<ChatMessage> current = switch (state.data) {
      Success(:final data) => data,
      _ => const [],
    };
    emit(ChatState.chat(
      data: DataState.success(data: current),
      isSending: true,
    ));
    try {
      final messages = await _chatRepository.sendMessage(content);
      emit(ChatState.chat(
        data: DataState.success(data: messages),
        isSending: false,
      ));
    } on DataError catch (e) {
      Flogger.w("Error sending chat message: $e");
      emit(ChatState.chat(
        data: DataState.failure(
          reason: ChatError.unknown(reason: e.toString()),
        ),
        isSending: false,
      ));
    } catch (e) {
      Flogger.w("Unexpected error sending chat message: $e");
      emit(ChatState.chat(
        data: DataState.failure(
          reason: ChatError.unknown(reason: e.toString()),
        ),
        isSending: false,
      ));
    }
  }

  Future<void> _clear(Emitter<ChatState> emit) async {
    await _chatRepository.clear();
    emit(const ChatState.chat(
      data: DataState.success(data: []),
      isSending: false,
    ));
  }
}
