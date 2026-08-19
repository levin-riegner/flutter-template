import 'package:flutter/foundation.dart';
import 'package:swiss_ai/app/config/environment.dart';
import 'package:swiss_ai/main_shared.dart';
import 'package:swiss_ai/util/dependencies.dart';

void main() async {
  mainShared(
    registerDependencies: () => Dependencies.register(
      environment: Environment.production(),
      isDebugBuild: kDebugMode,
    ),
  );
}
