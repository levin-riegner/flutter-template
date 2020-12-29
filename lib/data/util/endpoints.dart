class Endpoints {
  final String _baseUrl;

  const Endpoints(this._baseUrl)
      : assert(_baseUrl != null);

  String get articles => '$_baseUrl/api/organizations';
}
