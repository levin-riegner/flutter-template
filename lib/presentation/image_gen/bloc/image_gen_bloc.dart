import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/data/image_gen/model/generated_image.dart';
import 'package:swiss_ai/data/image_gen/repository/image_gen_repository.dart';
import 'package:swiss_ai/data/shared/model/error/data_error.dart';
import 'package:swiss_ai/presentation/image_gen/bloc/image_gen_error.dart';
import 'package:swiss_ai/presentation/image_gen/bloc/image_gen_event.dart';
import 'package:swiss_ai/presentation/image_gen/bloc/image_gen_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ImageGenBloc extends Bloc<ImageGenEvent, ImageGenState> {
  final ImageGenRepository _imageGenRepository;

  ImageGenBloc(this._imageGenRepository)
      : super(const ImageGenState.gallery(
          data: DataState.success(data: []),
          isGenerating: false,
        )) {
    on<ImageGenEvent>((event, emit) async {
      await event.when(
        generate: (prompt) => _generate(emit, prompt),
        clear: () => _clear(emit),
      );
    });
  }

  Future<void> _generate(
    Emitter<ImageGenState> emit,
    String prompt,
  ) async {
    final List<GeneratedImage> current = switch (state.data) {
      Success(:final data) => data,
      _ => const [],
    };
    emit(ImageGenState.gallery(
      data: DataState.success(data: current),
      isGenerating: true,
    ));
    try {
      final images = await _imageGenRepository.generate(prompt);
      emit(ImageGenState.gallery(
        data: DataState.success(data: images),
        isGenerating: false,
      ));
    } on DataError catch (e) {
      Flogger.w("Error generating image: $e");
      emit(ImageGenState.gallery(
        data: DataState.failure(
          reason: ImageGenError.unknown(reason: e.toString()),
        ),
        isGenerating: false,
      ));
    } catch (e) {
      Flogger.w("Unexpected error generating image: $e");
      emit(ImageGenState.gallery(
        data: DataState.failure(
          reason: ImageGenError.unknown(reason: e.toString()),
        ),
        isGenerating: false,
      ));
    }
  }

  Future<void> _clear(Emitter<ImageGenState> emit) async {
    await _imageGenRepository.clear();
    emit(const ImageGenState.gallery(
      data: DataState.success(data: []),
      isGenerating: false,
    ));
  }
}
