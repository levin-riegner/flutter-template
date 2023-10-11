abstract interface class RouteListener {
  /// Called when the route changes.
  void onRouteChanged({
    required String location,
    required String path,
    String? name,
  });
}
