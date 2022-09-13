import 'dart:async';

import 'package:app_versioning/app_versioning.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/theme.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_dialog.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/tools/qa_config.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';

import 'navigation/router/app_router.gr.dart';

class App extends StatefulWidget {
  final bool isSessionAvailable;

  const App({
    Key? key,
    required this.isSessionAvailable,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final appRouter = getIt<AppRouter>();
  final environment = getIt<Environment>();
  ShakeDetector? shakeDetector;

  late StreamSubscription _dynamicLinksSubscription;

  @override
  void initState() {
    super.initState();
    // Register observer to handle Shake detection on different App lifecycles
    if (environment.internal) {
      shakeDetector = getIt<ShakeDetector>();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (environment.internal) {
      switch (state) {
        case AppLifecycleState.resumed:
          shakeDetector?.stopListening();
          shakeDetector?.startListening();
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          shakeDetector?.stopListening();
          break;
      }
    } else {
      super.didChangeAppLifecycleState(state);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAppUpdateAvailable();
    _initPushNotifications();
    _initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QaConfig()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            debugShowMaterialGrid:
                context.watch<QaConfig>().debugShowMaterialGrid,
            showSemanticsDebugger:
                context.watch<QaConfig>().showSemanticsDebugger,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              Strings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Strings.supportedLocales,
            theme: AppTheme.lightTheme(),
            routerDelegate: appRouter.delegate(
              initialRoutes: [
                const BottomNavigationRoute(),
              ],
              navigatorObservers: kReleaseMode
                  ? () => [
                        FirebaseAnalyticsObserver(
                          analytics: FirebaseAnalytics.instance,
                        ),
                      ]
                  : AutoRouterDelegate.defaultNavigatorObserversBuilder,
            ),
            routeInformationParser: appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }

  // Versioning
  void _checkAppUpdateAvailable() async {
    // Check App Update Available
    final appVersioning = getIt.get<AppVersioning>();
    final appUpdateInfo = await appVersioning.getAppUpdateInfo();
    Flogger.i("Got app update info: $appUpdateInfo");
    final isOptionalUpdate =
        appUpdateInfo.updateType != AppUpdateType.Mandatory;
    if (appUpdateInfo.isUpdateAvailable) {
      if (getIt<AppRouter>().navigatorKey.currentState?.context == null) return;
      Flogger.i("Showing app update dialog");
      showDialog(
        context: getIt<AppRouter>().navigatorKey.currentState!.context,
        builder: (context) {
          return DSDialog(
            title: context.l10n.dialogAppUpdateTitle,
            description: context.l10n.dialogAppUpdateDescription,
            positiveButtonText: context.l10n.dialogAppUpdateConfirmationButton,
            positiveCallback: () {
              Flogger.i("Launching update");
              appVersioning.launchUpdate(updateInBackground: isOptionalUpdate);
            },
            negativeButtonText: isOptionalUpdate
                ? context.l10n.dialogAppUpdateDismissButton
                : null,
            negativeCallback: isOptionalUpdate
                ? () {
                    Flogger.i("Optional updated dismissed");
                    AutoRouter.of(context).pop();
                  }
                : null,
          );
        },
        barrierDismissible: isOptionalUpdate,
      );
    }
  }

  // Push
  void _initPushNotifications() async {
    PermissionStatus status = await Permission.notification.status;
    Flogger.i("Push notifications status: $status");
    if (status.isGranted) {
      // TODO: Register with push service
    }
  }

  // region Dynamic Links
  void _initDynamicLinks() async {
    // Register Dynamic Link Callback
    _dynamicLinksSubscription = FirebaseDynamicLinks.instance.onLink.listen(
      (event) {
        Flogger.i("Received dynamic link: $event");
        final Uri deepLink = event.link;
        _onDeepLink(deepLink);
      },
      onError: (error) => Flogger.w("Error getting dynamic link $error"),
    );

    // Check if app was opened by a Dynamic Link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      Flogger.i("Received dynamic link opening the app: $data");
      _onDeepLink(deepLink);
    }
  }

  void _onDeepLink(Uri deepLink) {
    // Navigate
    AutoRouter.of(getIt<AppRouter>().navigatorKey.currentState!.context)
        .navigateNamed(deepLink.path);
  }

  // endregion

  @override
  void dispose() {
    Dependencies.dispose();
    _dynamicLinksSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
