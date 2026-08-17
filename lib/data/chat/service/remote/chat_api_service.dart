import 'package:swiss_ai/data/shared/service/remote/api_response_mapper.dart';
import 'package:dio/dio.dart';

/// OpenAI-compatible chat-completions response for a local on-device model.
class ChatCompletionResponse {
  final String? content;

  const ChatCompletionResponse({this.content});

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List?;
    final first = (choices == null || choices.isEmpty) ? null : choices.first;
    final firstMessage = (first is Map) ? first['message'] : null;
    return ChatCompletionResponse(
      content: (firstMessage is Map) ? firstMessage['content'] as String? : null,
    );
  }
}

/// HTTP client for the on-device chat model.
///
/// The on-device model runs an OpenAI-compatible endpoint (for example a local
/// vLLM server). This service sends the conversation and maps the response.
class ChatApiService with ApiResponseMapper {
  final Dio client;
  final String endpoint;

  ChatApiService(this.client, {this.endpoint = "/chat/completions"});

  Future<String> sendChat(List<Map<String, String>> messages) async {
    try {
      final response = await client.post(
        endpoint,
        data: {
          "model": "llm",
          "messages": messages,
          "temperature": 0.7,
          "max_tokens": 2048,
        },
      );
      final parsed = ChatCompletionResponse.fromJson(response.data);
      final content = parsed.content;
      if (content == null || content.isEmpty) {
        throw StateError("Chat model returned empty response");
      }
      return content;
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
