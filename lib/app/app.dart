import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/presentation/util/styles/dimens.dart';
import 'package:flutter_template/presentation/util/styles/theme.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:flutter_template/util/tools/qa_config.dart';
import 'package:logging_flutter/flogger.dart';
import 'package:lr_app_versioning/app_versioning.dart';
import 'package:lr_design_system/config/ds_app.dart';
import 'package:lr_design_system/config/ds_config.dart';
import 'package:lr_design_system/views/ds_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'navigation/router/app_router.gr.dart';

class App extends StatefulWidget {
  final bool isSessionAvailable;

  App({
    Key? key,
    required this.isSessionAvailable,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final appRouter = getIt<AppRouter>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAppUpdateAvailable();
    _initPushNotifications();
    _initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return DSApp(
      dimens: AppDimens.regular(),
      config: DSConfig.fallback(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => QaConfig()),
        ],
        child: Builder(builder: (context) {
          return MaterialApp.router(
            debugShowMaterialGrid:
                context.watch<QaConfig>().debugShowMaterialGrid,
            showSemanticsDebugger:
                context.watch<QaConfig>().showSemanticsDebugger,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              Strings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Strings.supportedLocales,
            theme: AppTheme.lightTheme(),
            routerDelegate: appRouter.delegate(
              initialRoutes: [
                BottomNavigationRoute(),
              ],
              navigatorObservers: kReleaseMode
                  ? () => [
                        FirebaseAnalyticsObserver(
                            analytics: Analytics.firebaseAnalytics),
                      ]
                  : AutoRouterDelegate.defaultNavigatorObserversBuilder,
            ),
            routeInformationParser: appRouter.defaultRouteParser(),
          );
        }),
      ),
    );
  }

  // Versioning
  void _checkAppUpdateAvailable() async {
    // Check App Update Available
    final appVersioning = getIt.get<AppVersioning>();
    final appUpdateInfo = await appVersioning.getAppUpdateInfo();
    Flogger.i("Got app update info", object: appUpdateInfo);
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
    if (status.isGranted) {
      Flogger.i("Init Push Notifications: Granted");
      // TODO: Register with push service
    }
  }

  // region Dynamic Links
  void _initDynamicLinks() async {
    // Register Dynamic Link Callback
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          _onDeepLink(deepLink);
        }
      },
      onError: (OnLinkErrorException e) async {
        Flogger.w("Error getting dynamic link: ${e.message}", object: e);
      },
    );

    // Check if app was opened by a Dynamic Link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      _onDeepLink(deepLink);
    }
  }

  void _onDeepLink(Uri deepLink) {
    Flogger.i(
      "Received DeepLink with path: ${deepLink.path}",
      object: deepLink,
    );
    // Navigate
    AutoRouter.of(getIt<AppRouter>().navigatorKey.currentState!.context)
        .navigateNamed(deepLink.path);
  }

  // endregion

  @override
  void dispose() {
    Dependencies.dispose();
    super.dispose();
  }
}
