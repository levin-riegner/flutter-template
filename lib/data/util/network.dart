import 'package:chopper/chopper.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:flutter_template/data/util/json_serializable_converter.dart';

abstract class Network {
  static ChopperClient createHttpClient(
    String baseUrl,
    Future<String> getBearerToken(),
  ) {
    // Add your models here 👇
    final converter = JsonSerializableConverter({
      ArticlesApiResponse: (json) => ArticlesApiResponse.fromJson(json),
      ArticleApiModel: (json) => ArticleApiModel.fromJson(json),
    });

    // Create Chopper Client
    final chopper = ChopperClient(
      baseUrl: baseUrl,
      converter: converter,
      // errorConverter: JsonConverter(),
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
          newParameters["apiKey"] = Constants.API_KEY;
          return request.copyWith(parameters: newParameters);
        },
        CurlInterceptor(),
        HttpLoggingInterceptor(),
      ],
    );
    return chopper;
  }
}
