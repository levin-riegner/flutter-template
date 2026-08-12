import 'package:integration_test/integration_test_driver.dart';

/// Host driver for end-to-end tests. Run with:
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/app_flows_test.dart
Future<void> main() => integrationDriver();
