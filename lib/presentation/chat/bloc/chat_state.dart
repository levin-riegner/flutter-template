import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/presentation/chat/bloc/chat_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState.chat({
    required DataState<List<ChatMessage>, ChatError> data,
    required bool isSending,
  }) = _Chat;
}
