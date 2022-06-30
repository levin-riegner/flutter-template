import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/main_shared.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  // Init integration
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Dependencies.register(
    environment: Environment.staging(),
    useMocks: false,
    isDebugBuild: false,
  );
  mainShared();
  testWidgets('Dummy test', (WidgetTester tester) async {
    const correct = true;
    assert(correct == true);
  });
}
