import 'package:equatable/equatable.dart';

class WebViewUrls extends Equatable {
  final String _baseUrl;

  const WebViewUrls(this._baseUrl);

  String get about => "$_baseUrl/about";

  String get faqs => "$_baseUrl/faq";

  String get contact => "$_baseUrl/contact";

  String get termsAndConditions => "$_baseUrl/terms";

  String get privacyPolicy => "$_baseUrl/privacy";

  @override
  List<Object?> get props => [_baseUrl];
}
