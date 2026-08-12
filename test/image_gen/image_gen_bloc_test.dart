import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/image_gen/model/generated_image.dart';
import 'package:color_picker/data/image_gen/repository/image_gen_repository.dart';
import 'package:color_picker/presentation/image_gen/bloc/image_gen_bloc.dart';
import 'package:color_picker/presentation/image_gen/bloc/image_gen_error.dart';
import 'package:color_picker/presentation/image_gen/bloc/image_gen_event.dart';
import 'package:color_picker/presentation/image_gen/bloc/image_gen_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ImageGenRepository {}

void main() {
  group('ImageGenBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });
    group("ImageGenEvent.generate", () {
      const image = GeneratedImage(
        id: "0",
        prompt: "a cat",
        url: "https://img/1.png",
      );
      blocTest<ImageGenBloc, ImageGenState>(
        'should emit generating state then success with images',
        setUp: () => when(() => mockRepository.generate(any()))
            .thenAnswer((_) async => [image]),
        build: () => ImageGenBloc(mockRepository),
        act: (bloc) => bloc.add(const ImageGenEvent.generate(prompt: "a cat")),
        expect: () => [
          const ImageGenState.gallery(
              data: DataState.success(data: []), isGenerating: true),
          const ImageGenState.gallery(
              data: DataState.success(data: [image]), isGenerating: false),
        ],
      );
      blocTest<ImageGenBloc, ImageGenState>(
        'should emit failure when generation throws',
        setUp: () => when(() => mockRepository.generate(any()))
            .thenThrow(Exception("boom")),
        build: () => ImageGenBloc(mockRepository),
        act: (bloc) => bloc.add(const ImageGenEvent.generate(prompt: "a cat")),
        skip: 1,
        expect: () => [
          ImageGenState.gallery(
              data: DataState.failure(
                  reason: ImageGenError.unknown(reason: "Exception: boom")),
              isGenerating: false),
        ],
      );
    });

    group("ImageGenEvent.clear", () {
      blocTest<ImageGenBloc, ImageGenState>(
        'should clear images',
        setUp: () => when(() => mockRepository.clear())
            .thenAnswer((_) async {}),
        build: () => ImageGenBloc(mockRepository),
        act: (bloc) => bloc.add(const ImageGenEvent.clear()),
        expect: () => [
          const ImageGenState.gallery(
              data: DataState.success(data: []), isGenerating: false),
        ],
      );
    });
  });
}
