import 'dart:async';

import 'package:app_versioning/app_versioning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/deeplink_manager.dart';
import 'package:flutter_template/app/navigation/listener/analytics_route_listener.dart';
import 'package:flutter_template/app/navigation/listener/route_listener.dart';
import 'package:flutter_template/app/navigation/listener/theme_route_listener.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/redirect/console_route_redirect.dart';
import 'package:flutter_template/app/navigation/redirect/default_route_redirect.dart';
import 'package:flutter_template/app/navigation/router/app_router.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_cubit.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_state.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/theme.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_dialog.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/extensions/go_router_extension.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:flutter_template/util/tools/qa_config.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shake/shake.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  String get initialLocation =>
      deepLinkManager.getCurrentDeeplink(consume: false) ??
      ArticlesRoute().location;

  late final Environment environment = getIt<Environment>();
  late final ShakeDetector? shakeDetector =
      environment.internal ? getIt<ShakeDetector>() : null;
  late final DeepLinkManager deepLinkManager = getIt<DeepLinkManager>();
  late final AdaptiveThemeCubit themeCubit = AdaptiveThemeCubit();
  late final GoRouter router = AppRouterBuilder.buildRouter(
    rootNavigatorKey: NavigatorHolder.rootNavigatorKey,
    redirects: [
      ConsoleRouteRedirect(
        internalBuild: environment.internal,
      ),
      const DefaultRouteRedirect(),
    ],
    initialLocation: ArticlesRoute().location,
  );
  late final List<RouteListener> routeListeners = [
    AnalyticsRouteListener(Analytics.instance),
    ThemeRouteListener(themeCubit),
  ];
  late final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => QaConfig()),
    Provider<AdaptiveThemeCubit>(
      create: (context) => themeCubit,
      dispose: (context, cubit) => cubit.close(),
    ),
  ];

  StreamSubscription? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    // Lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    // Deeplinks
    _deepLinkSubscription = deepLinkManager.deeplink.listen(onDeeplinkReceived);
    // Router listener
    router.routerDelegate.addListener(_onRouteChanged);
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
        case AppLifecycleState.hidden:
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
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: BlocBuilder<AdaptiveThemeCubit, AdaptiveThemeState>(
        bloc: themeCubit,
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, adaptiveThemeState) {
          return AppView(
            debugShowMaterialGrid:
                context.watch<QaConfig>().debugShowMaterialGrid,
            showSemanticsDebugger:
                context.watch<QaConfig>().showSemanticsDebugger,
            themeMode: adaptiveThemeState == AdaptiveThemeState.light
                ? ThemeMode.light
                : ThemeMode.dark,
            routerConfig: router,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Dependencies.dispose();
    _deepLinkSubscription?.cancel();
    router.routerDelegate.removeListener(_onRouteChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      if (NavigatorHolder.context == null) return;
      Flogger.i("Showing app update dialog");
      showDialog(
        context: NavigatorHolder.context!,
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
                    Navigator.of(context).pop();
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

  // Route Observers
  void _onRouteChanged() {
    final location = router.location();
    final path = router.fullPath();
    final name = router.routeName();
    Flogger.i(
        "On route changed with location: $location, path: $path, name: $name");
    for (final listener in routeListeners) {
      listener.onRouteChanged(
        location: location.toString(),
        path: path,
        name: name,
      );
    }
  }

  // Deeplinks
  @visibleForTesting
  void onDeeplinkReceived(String? deeplink) async {
    if (deeplink == null) return;
    if (!context.mounted) return;
    // Navigate to deep link
    Flogger.i("Navigating to deep link: $deeplink");
    router.go(deeplink);
  }
}

class AppView extends StatelessWidget {
  final RouterConfig<Object>? routerConfig;
  final ThemeMode themeMode;
  final bool debugShowMaterialGrid;
  final bool showSemanticsDebugger;

  const AppView({
    Key? key,
    this.routerConfig,
    this.themeMode = ThemeMode.system,
    this.debugShowMaterialGrid = false,
    this.showSemanticsDebugger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowMaterialGrid: debugShowMaterialGrid,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        Strings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Strings.supportedLocales,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: routerConfig,
    );
  }
}
