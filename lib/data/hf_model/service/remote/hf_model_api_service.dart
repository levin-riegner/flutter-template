import 'package:color_picker/data/shared/service/remote/api_response_mapper.dart';
import 'package:dio/dio.dart';

/// Response wrapper for a HuggingFace Hub model listing.
class HfModelListResponse {
  final List<Map<String, dynamic>> models;

  const HfModelListResponse({required this.models});

  factory HfModelListResponse.fromJson(Object? data) {
    final list = (data is List) ? data : const <dynamic>[];
    return HfModelListResponse(
      models: list
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }
}

/// HTTP client for the HuggingFace Hub model catalogue.
///
/// Fetches downloadable models sorted by popularity (downloads desc) and lets
/// the repository filter + rank them into a top-3 shortlist.
class HfModelApiService with ApiResponseMapper {
  final Dio client;
  final String endpoint;

  HfModelApiService(this.client, {this.endpoint = "https://huggingface.co/api/models"});

  /// Fetches the most-downloaded models of a given pipeline family.
  Future<List<Map<String, dynamic>>> fetchModels({
    String pipelineTag = "text-generation",
    int limit = 50,
  }) async {
    try {
      final response = await client.get(
        endpoint,
        queryParameters: {
          "sort": "downloads",
          "direction": "-1",
          "limit": "$limit",
          "full": "true",
          "pipeline_tag": pipelineTag,
        },
      );
      return HfModelListResponse.fromJson(response.data).models;
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
