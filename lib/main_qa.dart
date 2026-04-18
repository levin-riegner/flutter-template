import 'package:flutter/foundation.dart';
import 'package:color_picker/app/config/environment.dart';
import 'package:color_picker/main_shared.dart';
import 'package:color_picker/util/dependencies.dart';

void main() async {
  mainShared(
    registerDependencies: () => Dependencies.register(
      environment: Environment.staging(),
      isDebugBuild: kDebugMode,
    ),
  );
}
