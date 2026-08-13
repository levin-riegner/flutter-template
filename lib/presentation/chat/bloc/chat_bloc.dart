import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/data/shared/model/error/data_error.dart';
import 'package:color_picker/presentation/chat/bloc/chat_error.dart';
import 'package:color_picker/presentation/chat/bloc/chat_event.dart';
import 'package:color_picker/presentation/chat/bloc/chat_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final PersonalitiesRepository? _personasRepository;

  ChatBloc(
    this._chatRepository, [
    this._personasRepository,
  ]) : super(const ChatState.chat(
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

  /// Resolves the system prompt for the active persona, if any is selected.
  Future<String?> _systemPromptForActivePersona() async {
    final personasRepository = _personasRepository;
    if (personasRepository == null) {
      return null;
    }
    final selectedId = await personasRepository.getSelectedId();
    if (selectedId == null) {
      return null;
    }
    final personas = await personasRepository.getAll();
    for (final persona in personas) {
      if (persona.id == selectedId) {
        Flogger.i("Using system prompt for persona: ${persona.name}");
        return persona.systemPrompt;
      }
    }
    return null;
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
      final systemPrompt = await _systemPromptForActivePersona();
      final messages =
          await _chatRepository.sendMessage(content, systemPrompt: systemPrompt);
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
