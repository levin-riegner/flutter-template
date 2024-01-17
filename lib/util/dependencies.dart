import 'dart:developer';

import 'package:app_versioning/app_versioning.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart'
    as fir_remote_config;
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/deeplink_manager.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';
import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:flutter_template/data/shared/service/local/user_config_service.dart';
import 'package:flutter_template/data/shared/service/remote/network.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:flutter_template/util/extensions/go_router_extension.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:flutter_template/util/integrations/app_updater.dart';
import 'package:flutter_template/util/integrations/branch_api.dart';
import 'package:flutter_template/util/integrations/branch_share.dart';
import 'package:flutter_template/util/integrations/datadog.dart';
import 'package:flutter_template/util/integrations/notifications/push_notifications_api_service.dart';
import 'package:flutter_template/util/integrations/notifications/push_notifications_helper.dart';
import 'package:flutter_template/util/integrations/remote_config.dart';
import 'package:flutter_template/util/tools/permissions_service.dart';
import 'package:flutter_template/util/tools/shake_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:isar/isar.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

abstract class Dependencies {
  static final List<IsarCollection> _userDataCollections = [];

  static Future<void> register({
    required Environment environment,
    required bool isDebugBuild,
  }) async {
    // Logging
    _initLogging(
      debugBuild: isDebugBuild,
      internalEnvironment: environment.internal,
    );

    // Environment
    getIt.registerSingleton<Environment>(environment);

    // Equatable (generate toString methods)
    EquatableConfig.stringify = true;

    // Secure Storage
    final secureStorage = SecureStorage();
    getIt.registerSingleton<SecureStorage>(secureStorage);

    // Shared Preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Clear Secure Storage on first run to prevent persistence across uninstall/reinstall
    if (sharedPreferences.getBool("first_run") ?? true) {
      await Future.wait([
        sharedPreferences.setBool("first_run", false),
        secureStorage.deleteAll(),
      ]);
    }

    // System directories
    final tempDirectory = await getTemporaryDirectory();
    final applicationDirectory = await getApplicationDocumentsDirectory();

    // Init date format with locale
    Intl.systemLocale = await findSystemLocale();
    final preferredLocales = await Devicelocale.preferredLanguages;

    // HttpClient
    final httpClient = Network.createHttpClient(
      environment.apiBaseUrl,
      apiKey: Constants.apiKey,
      locale: preferredLocales?.join(",") ?? "en",
      cacheDirectory: tempDirectory.path,
      getBearerToken: secureStorage.getUserAuthToken,
      onUnauthorized: () async {
        Flogger.i("On Unauthorized");
        await Dependencies.clearAllUserData();
        final context = NavigatorHolder.rootNavigatorKey.currentState!.context;
        if (!context.mounted) return;
        context.router.go("/");
        // Give some time for the navigation to complete and show alert
        await Future.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;
        AlertService.showAlert(
          context: context,
          title: context.l10n.loggedOutAlertTitle,
          message: context.l10n.loggedOutAlertDescription,
          type: AlertType.error,
        );
      },
      debugMode: isDebugBuild,
    );

    // Database
    final isar = await Database.init(
      directory: applicationDirectory.path,
    );
    // Open db collections
    final articlesCollection = isar.articleDbModels;
    // Save user collections as class var for logout
    _userDataCollections.addAll([]); // TODO: Add user collections here

    // Repositories
    getIt.registerSingleton<ArticleRepository>(
      ArticleRepository(
        ArticleApiService(httpClient),
        ArticleDbService(articlesCollection),
      ),
    );

    // Firebase
    await Firebase.initializeApp();

    // App Versioning
    final appVersioning = AppVersioning.firebaseService(
      remoteConfigKeys: const RemoteConfigKeys(
        minimumIosVersionKey: "minimumIosVersion",
        minimumAndroidVersionKey: "minimumAndroidVersion",
      ),
      updateConfig: const UpdateConfig(
        appStoreAppId: Constants.appstoreAppId,
        playStoreAppId: Constants.playstoreAppId,
        appstoreCountryCode: 'US',
      ),
    );
    getIt.registerSingleton<AppVersioning>(appVersioning);
    // Version tracking
    await appVersioning.tracker.track();
    // App Updater
    getIt.registerSingleton<AppUpdater>(AppUpdater(appVersioning));

    // User Configs
    final userConfig = UserConfigService(sharedPreferences);
    getIt.registerSingleton<UserConfigService>(userConfig);

    // Data Collection (GDPR)
    final dataCollectionEnabled = await userConfig.isDataCollectionEnabled();
    setDataCollectionEnabled(dataCollectionEnabled ?? false);

    // Permissions
    final permissionsService = PermissionsService();
    getIt.registerSingleton<PermissionsService>(permissionsService);

    // Deeplinks
    final deepLinkManager = DeepLinkManager(
      uriScheme: environment.deepLinkScheme,
    );
    getIt.registerSingleton<DeepLinkManager>(deepLinkManager);
    // DEV: Enable to test that the integration works
    // FlutterBranchSdk.validateSDKIntegration();
    final branchApi = BranchApi(
      environment.deepLinkScheme,
      onDeepLink: (uri) => deepLinkManager.handleDeepLink(uri),
      onUtmParameters: (source, medium, campaign) {
        Analytics.instance.trackUtmParameters(
          source: source,
          medium: medium,
          campaign: campaign,
        );
      },
    );
    getIt.registerSingleton<BranchApi>(branchApi);
    branchApi.initBranchSession();
    getIt.registerSingleton<BranchShareHelper>(
      BranchShareHelper(uriScheme: environment.deepLinkScheme),
    );

    // Push Notifications
    getIt.registerSingleton<PushNotificationsHelper>(
      PushNotificationsHelper(
        permissionsService,
        userConfig,
        PushNotificationsApiService(httpClient),
      ),
    );

    // Datadog
    await Datadog.initialize(
      config: DatadogConfig(
        clientToken: environment.datadogConfig.clientToken,
      ),
      environment: environment.environmentName,
    );

    // Crashlytics
    if (isDebugBuild) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    // Performance Monitoring
    if (isDebugBuild) {
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
    } else {
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    }
    // Remote Config
    final remoteConfig =
        RemoteConfig(fir_remote_config.FirebaseRemoteConfig.instance);
    await remoteConfig.init();
    remoteConfig.fetchAndActive(); // Refresh remote config without waiting
    getIt.registerSingleton<RemoteConfig>(remoteConfig);

    // Shake to show console
    if (environment.internal || isDebugBuild) {
      ShakeManager.init(
        onShake: () {
          Flogger.i("Shake detected");
          final router =
              NavigatorHolder.rootNavigatorKey.currentState?.context.router;
          if (router != null) {
            if (router.fullPath().startsWith(const ConsoleRoute().location)) {
              Flogger.i("Console is already open");
            } else {
              Flogger.i("Opening console");
              router.push(const ConsoleRoute().location);
            }
          }
        },
      );
    }
  }

  static void _initLogging({
    required bool debugBuild,
    required bool internalEnvironment,
  }) {
    const defaultLoggerName = "App";
    if (debugBuild) {
      Flogger.init(config: const FloggerConfig(loggerName: defaultLoggerName));
      Flogger.registerListener((record) {
        log(record.printable());
        if (record.stackTrace != null) log(record.stackTrace.toString());
      });
    } else {
      Flogger.init(
        config: const FloggerConfig(
          loggerName: defaultLoggerName,
          showDebugLogs: false,
        ),
      );
      // Register Datadog listener
      Flogger.registerListener((record) {
        if (record.loggerName == defaultLoggerName) {
          Datadog.logRecord(record.printable(), record.level);
        }
      });
      // Register Crashlytics log listener
      Flogger.registerListener((record) {
        if (record.loggerName == defaultLoggerName) {
          FirebaseCrashlytics.instance.log(record.printable());
        }
      });
      // Register Crashlytics error listener
      Flogger.registerListener((record) {
        if (record.level == Level.SEVERE) {
          FirebaseCrashlytics.instance.recordError(
            record.printable(),
            record.stackTrace,
          );
        }
      });
    }
    // Save logs for console
    if (internalEnvironment || debugBuild) {
      Flogger.registerListener(
        (record) => LogConsole.add(
          OutputEvent(record.level, [record.printable()]),
          bufferSize: 1000, // Remember the last X logs
        ),
      );
    }
  }

  /// Dispose all Dependencies
  static Future<void> dispose() async {
    Flogger.i("Disposing dependencies");
    try {
      // Close Database
      await Isar.getInstance()?.close();
      // Stop listening to Shake
      ShakeManager.stopListening();
      // Dispose DeepLink listener
      getIt.get<DeepLinkManager>().dispose();
      // Dispose Branch listener
      getIt.get<BranchApi>().dispose();
    } catch (e) {
      Flogger.w("Error disposing dependencies $e");
    }
  }

  /// Registers user to dependencies
  /// Call this method after registration
  static Future<void> registerUser(String userId, String email) async {
    Flogger.i("Registering user");
    Flogger.d("With id $userId and email $email");
    await Future.wait([
      FirebaseCrashlytics.instance.setUserIdentifier(userId),
      Analytics.identify(userId, email),
      Datadog.identify(userId: userId, email: email),
    ]);
    FlutterBranchSdk.setIdentity(userId);
  }

  /// Clears all local data
  /// Call this method after logout
  static Future<void> clearAllUserData() async {
    Flogger.i("Clearing all local data");
    FlutterBranchSdk.logout();
    await Future.wait([
      // Clear user boxes
      // Clearing the whole database won't allow for writing again
      // without closing the app or re-opening boxes
      ..._userDataCollections.map(
        (e) => e.isar.writeTxn(() async {
          e.clear();
        }),
      ),
      // Secure storage
      getIt.get<SecureStorage>().deleteAll(),
      // Analytics
      Analytics.logout(),
      // User Configs
      getIt.get<UserConfigService>().clear(),
      // Push notifications
      getIt.get<PushNotificationsHelper>().removeInstallation(),
    ]);
  }

  /// Enable or Disable Analytics Collection as per GDPR / CCPA compliance
  /// Call this method after requesting GDPR / CCPA permission
  ///
  /// IMPORTANT: Data Collection within this method is not used for Tracking purposes
  static Future<void> setDataCollectionEnabled(bool enabled) async {
    Flogger.i("Set data collection enabled: $enabled");
    FlutterBranchSdk.disableTracking(!enabled);
    await Future.wait([
      // Store value
      getIt<UserConfigService>().saveDataCollectionEnabled(enabled),
      // Toggle collection to 3rd party services
      Analytics.setCollectionEnabled(enabled),
      Datadog.setTrackingConsent(enabled),
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled),
      FirebasePerformance.instance.setPerformanceCollectionEnabled(enabled),
    ]);
  }
}
