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

  Future<String> sendChat(
    List<Map<String, String>> messages, {
    bool disableThinking = false,
  }) async {
    try {
      final response = await client.post(
        endpoint,
        data: {
          "model": "llm",
          "messages": messages,
          "temperature": 0.7,
          "max_tokens": 2048,
          // NOTE: the on-device SGLang server ignores the top-level
          // `enable_thinking` body flag; it must be passed via
          // chat_template_kwargs. When enabled, thinking tokens consume the
          // completion budget and can truncate strict-JSON output.
          if (disableThinking)
            "chat_template_kwargs": {"enable_thinking": false},
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

  /// Sends a single image (base64 data URL) with a text instruction to the
  /// on-device model and returns its text reply.
  ///
  /// Requires a vision-capable on-device model; throws [StateError] when the
  /// endpoint rejects image input.
  Future<String> transcribeImage({
    required String imageDataUrl,
    required String instruction,
    int maxTokens = 2048,
  }) async {
    try {
      final response = await client.post(
        endpoint,
        data: {
          "model": "llm",
          "messages": [
            {
              "role": "user",
              "content": [
                {"type": "text", "text": instruction},
                {
                  "type": "image_url",
                  "image_url": {"url": imageDataUrl},
                },
              ],
            },
          ],
          "temperature": 0,
          "max_tokens": maxTokens,
          // Transcription is a strict short-output task; disable the
          // model's thinking mode so it cannot burn the token budget.
          "chat_template_kwargs": {"enable_thinking": false},
        },
      );
      final parsed = ChatCompletionResponse.fromJson(response.data);
      final content = parsed.content;
      if (content == null || content.isEmpty) {
        throw StateError("Vision model returned empty response");
      }
      return content.trim();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
