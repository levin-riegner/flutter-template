import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.sendMessage({required String content}) =
      ChatEventSendMessage;

  const factory ChatEvent.clear() = ChatEventClear;
}
