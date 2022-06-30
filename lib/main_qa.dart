import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/main_shared.dart';
import 'package:flutter_template/util/dependencies.dart';

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
