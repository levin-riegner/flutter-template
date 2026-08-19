import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_error.freezed.dart';

@freezed
sealed class ChatError with _$ChatError {
  const factory ChatError.emptyResponse() = _EmptyResponse;
  const factory ChatError.unknown({String? reason}) = _Unknown;
}
