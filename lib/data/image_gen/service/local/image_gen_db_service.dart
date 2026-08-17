import 'package:swiss_ai/data/image_gen/model/generated_image.dart';

/// Local persistence for generated images.
///
/// Pure-Dart in-memory store (same convention as ChatDbService) so the image
/// generation feature is testable on the host without native plugins.
class ImageGenDbService {
  final List<GeneratedImage> _store = [];

  Future<List<GeneratedImage>> getImages() async {
    return List.unmodifiable(_store);
  }

  Stream<List<GeneratedImage>> images() async* {
    yield List.unmodifiable(_store);
  }

  Future<void> saveImage(GeneratedImage image) async {
    _store.add(image);
  }

  Future<void> clear() async {
    _store.clear();
  }
}
