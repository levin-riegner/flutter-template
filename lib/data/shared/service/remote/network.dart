import 'package:chopper/chopper.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:flutter_template/data/shared/service/remote/basic_json_serializable_converter.dart';

abstract class Network {
  static ChopperClient createHttpClient(
    final String baseUrl,
    final String apiKey,
    Future<String?> getBearerToken(),
  ) {
    // Add your models here 👇
    final converter = JsonSerializableConverter({
      ArticleApiModel: (json) => ArticleApiModel.fromJson(json),
      ArticlesApiResponse: (json) => ArticlesApiResponse.fromJson(json),
    });

    // Create Chopper Client
    final chopper = ChopperClient(
      baseUrl: baseUrl,
      converter: converter,
      errorConverter: converter,
      interceptors: [
        // Add Bearer Token
        (Request request) async {
          final token = await getBearerToken();
          if (token == null) return request;
          return applyHeader(request, "Authorization", token);
        },
        // Add API Key
        (Request request) async {
          final newParameters = Map<String, dynamic>.from(request.parameters);
          newParameters["apiKey"] = apiKey;
          return request.copyWith(parameters: newParameters);
        },
        CurlInterceptor(),
        // HttpLoggingInterceptor(),
      ],
    );
    return chopper;
  }
}
