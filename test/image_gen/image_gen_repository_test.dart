import 'package:color_picker/data/image_gen/repository/image_gen_repository.dart';
import 'package:color_picker/data/image_gen/service/local/image_gen_db_service.dart';
import 'package:color_picker/data/image_gen/service/remote/image_gen_api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';

class _MockApiService extends Mock implements ImageGenApiService {}

void main() {
  group("ImageGenRepository", () {
    final dbService = ImageGenDbService();
    final apiService = _MockApiService();
    final imageRepository = ImageGenRepository(apiService, dbService);
    setUp(() {
      reset(apiService);
      dbService.clear();
    });

    test("should append generated image on generate", () async {
      when(() => apiService.generate(any()))
          .thenAnswer((_) async =>
              const ImagesGenerationResponse(url: "https://img/1.png"));
      final images = await imageRepository.generate("a cat");
      assert(images.length == 1);
      assert(images[0].prompt == "a cat");
      assert(images[0].url == "https://img/1.png");
    });

    test("should pass prompt to api", () async {
      when(() => apiService.generate(any()))
          .thenAnswer((_) async => const ImagesGenerationResponse());
      await imageRepository.generate("a dog");
      verify(() => apiService.generate(any())).called(1);
    });
  });
}
