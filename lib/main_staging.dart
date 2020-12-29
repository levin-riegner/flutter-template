import 'package:flutter/foundation.dart';

import 'app/config/environment.dart';
import 'main_shared.dart';
import 'util/dependencies.dart';

void main() async {
  // Register Dependencies
  await Dependencies.register(
    environment: Environment.staging(),
    useMocks: false,
    isDebugBuild: kDebugMode,
  );

  mainShared();
}
