import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_gen_error.freezed.dart';

@freezed
sealed class ImageGenError with _$ImageGenError {
  const factory ImageGenError.emptyResponse() = _EmptyResponse;
  const factory ImageGenError.unknown({String? reason}) = _Unknown;
}
