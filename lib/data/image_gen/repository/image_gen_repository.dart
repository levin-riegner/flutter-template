import 'package:color_picker/data/image_gen/model/generated_image.dart';
import 'package:color_picker/data/image_gen/service/local/image_gen_db_service.dart';
import 'package:color_picker/data/image_gen/service/remote/image_gen_api_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ImageGenRepository {
  final ImageGenApiService _apiService;
  final ImageGenDbService _dbService;
  int _idCounter = 0;

  ImageGenRepository(
    this._apiService,
    this._dbService,
  );

  Future<List<GeneratedImage>> getImages() async {
    return _dbService.getImages();
  }

  /// Generates an image for the given prompt, persists it, and returns the
  /// full gallery of generated images.
  Future<List<GeneratedImage>> generate(String prompt) async {
    Flogger.i("Generating image for prompt: $prompt");
    final result = await _apiService.generate(prompt);
    final generated = GeneratedImage(
      id: '${_idCounter++}',
      prompt: prompt,
      url: result.url,
      localPath: result.b64Json,
    );
    await _dbService.saveImage(generated);
    return _dbService.getImages();
  }

  Future<void> clear() async {
    await _dbService.clear();
  }
}
