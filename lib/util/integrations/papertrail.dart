import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_paper_trail/flutter_paper_trail.dart';
import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class PaperTrail {
  const PaperTrail._();

  static bool _loggingEnabled = false;

  static Future<void> init({
    required String hostName,
    required String programName,
    required int port,
  }) async {
    // Init Papertrail
    await FlutterPaperTrail.initLogger(
      hostName: hostName,
      programName: programName.replaceAll(" ", "_"),
      port: port,
      machineName: programName.replaceAll(" ", "_"),
    );
  }

  static Future<void> setLoggingEnabled(bool enabled) async {
    _loggingEnabled = enabled;
  }

  static Future<void> setUserId(String id) async {
    await FlutterPaperTrail.setUserId(id);
  }

  static Future<void> logRecord(String message, Level recordLevel) async {
    if (!_loggingEnabled) return;
    // UserId
    var userId = await getIt.get<SecureStorage>().getUserId();
    if (userId != null && userId.length > 7) {
      userId = userId.substring(0, 7);
    }

    // System Variables
    final info = await PackageInfo.fromPlatform();
    final versionName = info.version;
    var deviceInfoString = "";
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final sdkInt = androidInfo.version.sdkInt;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      deviceInfoString =
          'Android $release (SDK $sdkInt), $manufacturer, $model';
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      final name = iosInfo.name;
      final model = iosInfo.model;
      deviceInfoString = 'iOS $systemName $version, $name, $model';
    }

    // Papertrail message
    final papertrailMessage =
        "user_id=$userId; version_name=$versionName; device=$deviceInfoString; message=$message";

    final level = LogLevelFactory.fromRecordLevel(recordLevel);
    switch (level) {
      case LogLevel.error:
        await FlutterPaperTrail.logError(papertrailMessage);
        break;
      case LogLevel.warning:
        await FlutterPaperTrail.logWarning(papertrailMessage);
        break;
      case LogLevel.info:
        await FlutterPaperTrail.logInfo(papertrailMessage);
        break;
      default:
        break;
    }
  }
}

abstract class LogLevelFactory {
  static LogLevel fromRecordLevel(Level level) {
    switch (level.value) {
      case Levels.config:
        return LogLevel.debug;
      case Levels.info:
        return LogLevel.info;
      case Levels.warning:
        return LogLevel.warning;
      case Levels.severe:
      case Levels.shout:
        return LogLevel.error;
      default:
        return LogLevel.debug;
    }
  }
}

enum LogLevel { error, warning, info, debug }

abstract class Levels {
  static const config = 700;
  static const info = 800;
  static const warning = 900;
  static const severe = 1000;
  static const shout = 1200;
}
