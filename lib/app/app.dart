import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/deeplink_manager.dart';
import 'package:flutter_template/app/navigation/listener/analytics_route_listener.dart';
import 'package:flutter_template/app/navigation/listener/route_listener.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/redirect/auth_route_redirect.dart';
import 'package:flutter_template/app/navigation/redirect/console_route_redirect.dart';
import 'package:flutter_template/app/navigation/redirect/default_route_redirect.dart';
import 'package:flutter_template/app/navigation/router/app_router.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_cubit.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_state.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/theme_factory.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/extensions/go_router_extension.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:flutter_template/util/integrations/app_updater.dart';
import 'package:flutter_template/util/integrations/branch_api.dart';
import 'package:flutter_template/util/integrations/notifications/push_notifications_helper.dart';
import 'package:flutter_template/util/tools/qa_config.dart';
import 'package:flutter_template/util/tools/shake_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  String get initialLocation =>
      deepLinkManager.getCurrentDeeplink(consume: false) ??
      const ArticlesRoute().location;

  late final Environment environment = getIt<Environment>();
  late final AppUpdater appUpdater = getIt<AppUpdater>();
  late final DeepLinkManager deepLinkManager = getIt<DeepLinkManager>();
  late final BranchApi branchApi = getIt<BranchApi>();
  late final PushNotificationsHelper pushNotificationsHelper =
      getIt<PushNotificationsHelper>();
  late final AdaptiveThemeCubit themeCubit = AdaptiveThemeCubit();
  late final GoRouter router = AppRouterBuilder.buildRouter(
    rootNavigatorKey: NavigatorHolder.rootNavigatorKey,
    redirects: [
      ConsoleRouteRedirect(
        internalBuild: environment.internal,
      ),
      const DefaultRouteRedirect(),
      AuthRouteRedirect(
        unauthenticatedDefaultRoute: const LoginRoute().location,
        hasSessionAvailable: () => getIt<AuthRepository>().isSessionAvailable,
      ),
    ],
    initialLocation: initialLocation,
  );
  late final List<RouteListener> routeListeners = [
    AnalyticsRouteListener(Analytics.instance),
  ];
  late final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => QaConfig()),
    Provider<AdaptiveThemeCubit>(
      create: (context) => themeCubit,
      dispose: (context, cubit) => cubit.close(),
    ),
  ];

  final CompositeSubscription _subscriptions = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    // Track Analytics
    Analytics.instance.track(AnalyticsEvent.appOpen());
    // Lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    // App updater
    appUpdater.performUpdateIfAvailable();
    // Router listener
    router.routerDelegate.addListener(_onRouteChanged);
    // Deeplinks
    _subscriptions.add(
      deepLinkManager.deeplink.listen(onDeeplinkReceived),
    );
    // Push Notifications
    _subscriptions.add(
      pushNotificationsHelper
          .subscribeToToken(pushNotificationsHelper.saveInstallation),
    );
    _subscriptions.add(
      pushNotificationsHelper.subscribeToMessages(branchApi.handleBranchLink),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (environment.internal) {
      switch (state) {
        case AppLifecycleState.resumed:
          ShakeManager.startListening();
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
          ShakeManager.stopListening();
          break;
      }
    } else {
      super.didChangeAppLifecycleState(state);
    }
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
    _subscriptions.clear();
    router.routerDelegate.removeListener(_onRouteChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
    super.key,
    this.routerConfig,
    this.themeMode = ThemeMode.system,
    this.debugShowMaterialGrid = false,
    this.showSemanticsDebugger = false,
  });

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
      theme: ThemeFactory.lightTheme(),
      darkTheme: ThemeFactory.darkTheme(),
      themeMode: themeMode,
      routerConfig: routerConfig,
    );
  }
}
