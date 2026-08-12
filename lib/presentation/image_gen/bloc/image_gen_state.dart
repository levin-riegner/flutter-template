import 'package:color_picker/data/image_gen/model/generated_image.dart';
import 'package:color_picker/presentation/image_gen/bloc/image_gen_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_gen_state.freezed.dart';

@freezed
sealed class ImageGenState with _$ImageGenState {
  const factory ImageGenState.gallery({
    required DataState<List<GeneratedImage>, ImageGenError> data,
    required bool isGenerating,
  }) = _Gallery;
}
