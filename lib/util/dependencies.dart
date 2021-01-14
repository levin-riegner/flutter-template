import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paper_trail/flutter_paper_trail.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/data/article/repository/article_data_repository.dart';
import 'package:flutter_template/data/article/repository/article_mock_repository.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/util/database.dart';
import 'package:flutter_template/data/util/network.dart';
import 'package:flutter_template/data/common/service/secure_storage.dart';
import 'package:flutter_template/util/console/console_screen.dart';
import 'package:flutter_template/util/integrations/papertrail.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:meta/meta.dart';
import 'package:shake/shake.dart';

import 'tools/flogger.dart';

final getIt = GetIt.instance;

abstract class Dependencies {
  static Future<void> register({
    @required Environment environment,
    @required bool useMocks,
    @required bool isDebugBuild,
  }) async {
    // Environment
    getIt.registerSingleton<Environment>(environment);

    // Configs
    // Secure Storage
    final secureStorage = SecureStorage();
    getIt.registerSingleton<SecureStorage>(secureStorage);
    // HttpClient
    final httpClient = Network.createHttpClient(
        environment.apiBaseUrl, () => secureStorage.getUserAuthToken());

    // Database
    await Database.init(secureStorage);
    final databaseEncryption =
        await Database.getEncryptionCipher(secureStorage);
    // Open db boxes
    final articlesBox = await Hive.openBox<ArticleDbModel>(Database.ArticleBox,
        encryptionCipher: databaseEncryption);

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
    // Shake detector for Console
    if (environment.isInternal) {
      final shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
        NavigatorHolder.navigatorKey.currentState
            .push(MaterialPageRoute(builder: (_) => ConsoleScreen()));
      });
      // Save logs for console
      Flogger.registerListener((record) => LogConsole.add(OutputEvent(record.level.toLoggerLevel(), [record.message])));
      getIt.registerSingleton<ShakeDetector>(shakeDetector);
    }

    // endregion
  }

  /// Dispose all Dependencies
  static Future<void> dispose() async {
    // Close Database
    await Hive.close();
    // Stop listening to Shake
    getIt.get<ShakeDetector>().stopListening();
  }

  /// Registers user to dependencies
  static Future<void> registerUser(String userId, String email) async {
    return Future.wait([
      FlutterPaperTrail.setUserId(userId),
      FirebaseCrashlytics.instance.setUserIdentifier(userId),
    ]);
  }

  /// Clears all local data
  static Future<void> clearAllLocalData() async {
    // Database
    await Hive.deleteFromDisk();
    // Secure storage
    await getIt.get<SecureStorage>().deleteAll();
  }
}
