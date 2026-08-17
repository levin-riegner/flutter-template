import 'package:swiss_ai/data/shared/service/remote/api_response_mapper.dart';
import 'package:dio/dio.dart';

/// Captures audio and transcribes it with an on-device model.
///
/// Encapsulates the capture/transcription backend so the feature is testable
/// on the host. The default in-memory implementation records a placeholder
/// transcript; production would swap in a microphone + STT (e.g. whisper).
class RecordingApiService with ApiResponseMapper {
  final Dio client;
  final String endpoint;

  RecordingApiService(this.client, {this.endpoint = "/audio/transcriptions"});

  /// Returns the transcript for a capture. [audioBytes] is the raw audio; on
  /// devices with no capture, pass null to exercise the transcription path.
  Future<String> transcribe({List<int>? audioBytes, String title = ''}) async {
    try {
      final response = await client.post(
        endpoint,
        data: {
          "model": "audio-llm",
          "title": title,
        },
      );
      final map = (response.data is Map) ? (response.data as Map) : null;
      final text = (map is Map) ? map['text'] as String? : null;
      if (text == null || text.isEmpty) {
        throw StateError("Transcription returned empty text");
      }
      return text;
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
