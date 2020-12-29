import 'package:flutter_paper_trail/flutter_paper_trail.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

abstract class PaperTrail {
  static Future<void> init({
    @required String hostName,
    @required String programName,
    @required int port,
    @required String machineName,
  }) async {
    await FlutterPaperTrail.initLogger(
      hostName: hostName,
      programName: programName,
      port: port,
      machineName: machineName,
    );
  }

  static Future<void> logRecord(String message, Level recordLevel) async {
    final level = LogLevelFactory.fromRecordLevel(recordLevel);
    switch (level) {
      case LogLevel.error:
        await FlutterPaperTrail.logError(message);
        break;
      case LogLevel.warning:
        await FlutterPaperTrail.logWarning(message);
        break;
      case LogLevel.info:
        await FlutterPaperTrail.logInfo(message);
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
