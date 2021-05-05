import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app/config/environment.dart';
import 'main_shared.dart';
import 'util/dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register Dependencies
  await Dependencies.register(
    environment: Environment.staging(),
    useMocks: false,
    isDebugBuild: kDebugMode,
  );

  mainShared();
}
