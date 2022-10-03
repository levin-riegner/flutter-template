import 'dart:developer';

import 'package:app_versioning/app_versioning.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/router/app_router.gr.dart';
import 'package:flutter_template/data/article/repository/article_data_repository.dart';
import 'package:flutter_template/data/article/repository/article_mock_repository.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';
import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:flutter_template/data/shared/service/local/user_config_service.dart';
import 'package:flutter_template/data/shared/service/remote/network.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:flutter_template/util/integrations/papertrail.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

abstract class Dependencies {
  static final List<IsarCollection> _userDataCollections = [];

  static Future<void> register({
    required Environment environment,
    required bool useMocks,
    required bool isDebugBuild,
  }) async {
    // Environment
    getIt.registerSingleton<Environment>(environment);
    // Equatable (generate toString methods)
    EquatableConfig.stringify = true;

    // AutoRouter
    final appRouter = AppRouter(NavigatorHolder.navigatorKey);
    getIt.registerSingleton<AppRouter>(appRouter);

    // Configs
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
    // HttpClient
    final httpClient = Network.createHttpClient(
      environment.apiBaseUrl,
      Constants.apiKey,
      () => secureStorage.getUserAuthToken(),
      debugMode: isDebugBuild,
    );
    // Database
    final isar = await Database.init();
    // Open db collections
    final articlesCollection = isar.articleDbModels;
    // Save user collections as class var for logout
    _userDataCollections.addAll([]); // TODO: Add user collections here
    // Repositories
    getIt.registerSingleton<ArticleRepository>(
      useMocks
          ? ArticleMockRepository()
          : ArticleDataRepository(
              ArticleApiService(httpClient),
              ArticleDbService(articlesCollection),
            ),
    );

    // region Integrations
    // Firebase
    await Firebase.initializeApp();
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
    // Logging
    const defaultLoggerName = "App";
    if (isDebugBuild) {
      Flogger.init(config: const FloggerConfig(loggerName: defaultLoggerName));
      Flogger.registerListener((record) => log(record.message));
    } else {
      Flogger.init(config: const FloggerConfig(showDebugLogs: false));
      // Init PaperTrail
      await PaperTrail.init(
        hostName: environment.loggingUrl,
        programName: environment.appName,
        port: environment.loggingPort,
      );
      Flogger.registerListener((record) {
        if (record.loggerName == defaultLoggerName) {
          PaperTrail.logRecord(record.message, record.level);
        }
        // TODO: Consider priting curls or http requests filtering user data
      });
      // Register Crashlytics listener
      Flogger.registerListener((record) {
        if (record.loggerName == defaultLoggerName) {
          FirebaseCrashlytics.instance.log(record.message);
        }
      });
    }
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
    // User Configs
    final userConfig = UserConfigService(sharedPreferences);
    getIt.registerSingleton<UserConfigService>(userConfig);
    // Analytics tracking
    final dataCollectionEnabled = await userConfig.isDataCollectionEnabled();
    // TODO: Set the default data collection policy for your app
    setDataCollectionEnabled(
        dataCollectionEnabled ?? true || environment.internal);
    // Shake detector for Console
    if (environment.internal) {
      final shakeDetector = ShakeDetector.autoStart(
        shakeThresholdGravity: 2,
        onPhoneShake: () {
          appRouter.navigate(
            const ConsoleRouter(),
          );
        },
      )..startListening();
      // Save logs for console
      Flogger.registerListener((record) => LogConsole.add(
            OutputEvent(record.level, [record.message]),
            bufferSize: 1000, // Remember the last X logs
          ));
      getIt.registerSingleton<ShakeDetector>(shakeDetector);
    }

    // endregion
  }

  /// Dispose all Dependencies
  static Future<void> dispose() async {
    Flogger.i("Disposing dependencies");
    // Close Database
    await Isar.getInstance()?.close();
    // Stop listening to Shake
    if (getIt.get<Environment>().internal) {
      getIt.get<ShakeDetector>().stopListening();
    }
  }

  /// Registers user to dependencies
  /// Call this method after registration
  static Future<void> registerUser(String userId, String email) async {
    Flogger.i("Registering user");
    Flogger.d("With id $userId and email $email");
    await Future.wait([
      if (kReleaseMode) PaperTrail.setUserId(userId),
      FirebaseCrashlytics.instance.setUserIdentifier(userId),
      Analytics.identify(userId, email),
    ]);
  }

  /// Clears all local data
  static Future<void> clearAllLocalData() async {
    Flogger.i("Clearing all local data");
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      // Clear user boxes
      // Clearing the whole database won't allow for writing again
      // without closing the app or re-opening boxes
      ..._userDataCollections.map((e) => e.clear()),
      // Secure storage
      getIt.get<SecureStorage>().deleteAll(),
      // Analytics
      Analytics.logout(),
      // User Configs
      getIt.get<UserConfigService>().clear(),
      // Shared Preferences
      preferences.clear(),
    ]);
  }

  /// Enable or Disable Analytics Collection as per GDPR / CCPA compliance
  /// Call this method after requesting GDPR / CCPA permission
  static Future<void> setDataCollectionEnabled(bool enabled) async {
    Flogger.i("Set data collection enabled");
    await Future.wait([
      // Toggle collection to 3rd party services
      Analytics.setCollectionEnabled(enabled),
      PaperTrail.setLoggingEnabled(enabled),
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled),
    ]);
  }
}
