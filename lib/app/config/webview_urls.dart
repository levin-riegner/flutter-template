class WebViewUrls {

  final String _baseUrl;

  WebViewUrls(this._baseUrl);

  String get about => "$_baseUrl/about";

  String get faqs => "$_baseUrl/faq";

  String get contact => "$_baseUrl/contact";

  String get termsAndConditions => "$_baseUrl/terms";

  String get privacyPolicy => "$_baseUrl/privacy";

}