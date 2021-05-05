import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/data/article/repository/article_data_repository.dart';
import 'package:flutter_template/data/article/repository/article_mock_repository.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';
import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:flutter_template/data/shared/service/remote/network.dart';
import 'package:flutter_template/util/console/console_screen.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:flutter_template/util/integrations/papertrail.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logging_flutter/flogger.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:lr_app_versioning/app_versioning.dart';
import 'package:shake/shake.dart';

final getIt = GetIt.instance;

abstract class Dependencies {
  static List<Box> _userDataBoxes = [];

  static Future<void> register({
    required Environment environment,
    required bool useMocks,
    required bool isDebugBuild,
  }) async {
    // Environment
    getIt.registerSingleton<Environment>(environment);

    // Configs
    // Secure Storage
    final secureStorage = SecureStorage();
    getIt.registerSingleton<SecureStorage>(secureStorage);
    // HttpClient
    final httpClient = Network.createHttpClient(
      environment.apiBaseUrl,
      Constants.API_KEY,
      () => secureStorage.getUserAuthToken(),
    );
    // Database
    await Database.init(secureStorage);
    final databaseEncryption =
        await Database.getEncryptionCipher(secureStorage);
    // Open db boxes
    final articlesBox = await Hive.openBox<ArticleDbModel>(
      Database.ArticleBox,
      encryptionCipher: databaseEncryption,
    );
    // Save user boxes as class var for logout
    _userDataBoxes.addAll([]);
    // Repositories
    getIt.registerSingleton<ArticleRepository>(
      useMocks
          ? ArticleMockRepository()
          : ArticleDataRepository(
              ArticleApiService.create(httpClient),
              ArticleDbService(articlesBox),
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
    // Logging
    if (isDebugBuild) {
      Flogger.showDebugLogs(true);
      Flogger.registerListener((record) => log(record.message));
    } else {
      // Init PaperTrail
      await PaperTrail.init(
        hostName: environment.loggingUrl,
        programName: environment.appName,
        port: environment.loggingPort,
      );
      Flogger.registerListener((record) {
        if (!record.mightContainSensitiveData) {
          PaperTrail.logRecord(record.message, record.level);
        }
      });
      // Register Crashlytics listener
      Flogger.registerListener((record) {
        if (!record.mightContainSensitiveData) {
          FirebaseCrashlytics.instance.log(record.message);
        }
      });
    }
    // App Versioning
    final appVersioning = AppVersioning.firebaseService(
      remoteConfigKeys: RemoteConfigKeys(
        minimumIosVersionKey: "minimumIosVersion",
        minimumAndroidVersionKey: "minimumAndroidVersion",
      ),
      updateConfig: UpdateConfig(
        appStoreAppId: Constants.APPSTORE_APP_ID,
        playStoreAppId: Constants.PLAYSTORE_APP_ID,
      ),
    );
    getIt.registerSingleton<AppVersioning>(appVersioning);
    // Version tracking
    await appVersioning.tracker.track();
    // Shake detector for Console
    if (environment.isInternal) {
      final shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
        NavigatorHolder.navigatorKey.currentState
            ?.push(MaterialPageRoute(builder: (_) => ConsoleScreen()));
      });
      // Save logs for console
      Flogger.registerListener((record) =>
          LogConsole.add(OutputEvent(record.level, [record.message])));
      getIt.registerSingleton<ShakeDetector>(shakeDetector);
    }

    // endregion
  }

  /// Dispose all Dependencies
  static Future<void> dispose() async {
    Flogger.i("Disposing dependencies");
    // Close Database
    await Hive.close();
    // Stop listening to Shake
    if (getIt.get<Environment>().isInternal) {
      getIt.get<ShakeDetector>().stopListening();
    }
  }

  /// Registers user to dependencies
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
    await Future.wait([
      // Clear user boxes
      // Clearing the whole database won't allow for writing again
      // without closing the app or re-opening boxes
      ..._userDataBoxes.map((e) => e.clear()),
      // Secure storage
      getIt.get<SecureStorage>().deleteAll(),
      // Analytics
      Analytics.logout(),
    ]);
  }
}
