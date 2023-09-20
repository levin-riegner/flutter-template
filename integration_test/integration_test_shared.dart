import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/main_shared.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

IntegrationTestWidgetsFlutterBinding ensureInitialized() {
  return IntegrationTestWidgetsFlutterBinding.ensureInitialized();
}

Future<IntegrationTestWidgetsFlutterBinding> initAppAndEnsureInitialized({
  Environment? environment,
  bool useMocks = true,
}) async {
  environment ??= Environment.staging();
  mainShared(
    registerDependencies: () => Dependencies.register(
      environment: environment!,
      isDebugBuild: true,
    ),
  );
  return ensureInitialized();
}

void timeout({required int seconds}) {
  Future.delayed(Duration(seconds: seconds))
      .then((value) => fail("Timeout exceeded"));
}
