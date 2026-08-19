import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_gen_event.freezed.dart';

@freezed
sealed class ImageGenEvent with _$ImageGenEvent {
  const factory ImageGenEvent.generate({required String prompt}) =
      ImageGenEventGenerate;

  const factory ImageGenEvent.clear() = ImageGenEventClear;
}
