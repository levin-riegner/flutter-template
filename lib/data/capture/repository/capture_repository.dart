import 'dart:convert';
import 'dart:io';

import 'package:swiss_ai/data/chat/service/remote/chat_api_service.dart';

/// Camera capture -> on-device transcription (OCR).
///
/// Captures a photo via [ImageFile] and sends it to the vision-capable
/// on-device model for text extraction. No native OCR dependency — the
/// 27B on-device model does the reading.
class CaptureRepository {
  final ChatApiService _api;

  CaptureRepository(this._api);

  /// Transcribes the image at [path] to text.
  ///
  /// [instruction] defaults to "Read out any text visible in this image.
  /// Reply with only the text."; pass a custom instruction to get
  /// structured output (JSON, summaries, etc.).
  Future<String> transcribe(
    String path, {
    String instruction =
        'Read out any text visible in this image. '
        'Reply with only the text, preserving line breaks.',
    int maxTokens = 2048,
  }) async {
    final file = File(path);
    if (!await file.exists()) {
      throw const FormatException('Image file not found');
    }
    final bytes = await file.readAsBytes();
    final dataUrl = 'data:image/jpeg;base64,'
        '${base64.encode(bytes)}';
    return _api.transcribeImage(
      imageDataUrl: dataUrl,
      instruction: instruction,
      maxTokens: maxTokens,
    );
  }
}
