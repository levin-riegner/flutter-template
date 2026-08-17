import 'package:swiss_ai/data/shared/service/remote/api_response_mapper.dart';
import 'package:dio/dio.dart';

/// OpenAI-compatible images-generations response for a local on-device model.
class ImagesGenerationResponse {
  final String? url;
  final String? b64Json;

  const ImagesGenerationResponse({this.url, this.b64Json});

  factory ImagesGenerationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List?;
    final first = (data == null || data.isEmpty) ? null : data.first;
    final map = (first is Map) ? first : null;
    return ImagesGenerationResponse(
      url: (map is Map) ? map['url'] as String? : null,
      b64Json: (map is Map) ? map['b64_json'] as String? : null,
    );
  }
}

/// HTTP client for the on-device image-generation model.
///
/// The on-device model runs an OpenAI-compatible images endpoint (for example
/// a local diffusion server). This service sends a prompt and maps either a
/// remote URL or a base64-encoded image payload.
class ImageGenApiService with ApiResponseMapper {
  final Dio client;
  final String endpoint;

  ImageGenApiService(this.client, {this.endpoint = "/images/generations"});

  Future<ImagesGenerationResponse> generate(String prompt) async {
    try {
      final response = await client.post(
        endpoint,
        data: {
          "model": "image-llm",
          "prompt": prompt,
          "n": 1,
          "size": "1024x1024",
        },
      );
      return ImagesGenerationResponse.fromJson(response.data);
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
