import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/deeplink_manager.dart';
import 'package:flutter_template/app/navigation/listener/analytics_route_listener.dart';
import 'package:flutter_template/app/navigation/listener/theme_route_listener.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/redirect/console_route_redirect.dart';
import 'package:flutter_template/app/navigation/redirect/default_route_redirect.dart';
import 'package:flutter_template/app/navigation/router/app_router.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_cubit.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:logging_flutter/logging_flutter.dart';

void mainShared({
  required Future<void> Function() registerDependencies,
}) async {
  // Run Zoned App
  runZonedGuarded<Future<void>>(() async {
    // Ensure WidgetsBinding is initialized
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // Delay first frame to allow for dependencies initialization
    widgetsBinding.deferFirstFrame();
    // Log Global Flutter Errors
    FlutterError.onError = (details) {
      Zone.current.handleUncaughtError(
          details.exception, details.stack ?? StackTrace.empty);
    };
    // Enable only portrait mode
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    // Register Dependencies
    await registerDependencies();
    // Create Router
    final router = AppRouterBuilder.buildRouter(
      rootNavigatorKey: NavigatorHolder.rootNavigatorKey,
      redirects: [
        ConsoleRouteRedirect(
          internalBuild: getIt.get<Environment>().internal,
        ),
        const DefaultRouteRedirect(),
      ],
      initialLocation: ArticlesRoute().location,
    );
    // Run App
    final themeCubit = AdaptiveThemeCubit();
    // TODO: Encapsulate app creation and app state
    runApp(App(
      router: router,
      isSessionAvailable: false,
      deepLinkManager: getIt<DeepLinkManager>(),
      routeListeners: [
        AnalyticsRouteListener(Analytics.instance),
        ThemeRouteListener(themeCubit),
      ],
      themeCubit: themeCubit,
    ));
    // Remove native launch screen and begin Flutter take over
    widgetsBinding.allowFirstFrame();
  }, (Object error, StackTrace stackTrace) {
    // Catch and log crashes
    Flogger.e("Unhandled error: $error", stackTrace: stackTrace);
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      // Log stack trace separately (for better external visualization)
      Flogger.e("Stack trace: ${stackTrace.toString().replaceAll("\n", " ")}");
    }
  });
}
