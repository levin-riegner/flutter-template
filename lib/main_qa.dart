import 'package:flutter/foundation.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/main_shared.dart';
import 'package:flutter_template/util/dependencies.dart';

void main() async {
  mainShared(
    registerDependencies: () => Dependencies.register(
      environment: Environment.staging(),
      isDebugBuild: kDebugMode,
    ),
  );
}
