import 'dart:developer';

// import 'package:device_info/device_info.dart';
// import 'package:droplette/util/constants.dart';
// import 'package:droplette/util/paper_trail_utils.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_paper_trail/flutter_paper_trail.dart';
import 'package:logging/logging.dart';

class Flogger {
  static final loggerName = "App";
  static Logger _logger;

  Flogger._() {}

  static debug(String message, {Object object}) {
    _log(message, severity: Level.CONFIG, object: object);
  }

  static info(String message, {Object object}) {
    _log(message, severity: Level.INFO, object: object);
  }

  static warning(String message, {Object object}) {
    _log(message, severity: Level.WARNING, object: object);
  }

  static error(String message, {Object object, StackTrace stackTrace}) {
    _log(message,
        severity: Level.SEVERE, object: object, stackTrace: stackTrace);
  }

  static _log(String message,
      {Level severity = Level.CONFIG, Object object, StackTrace stackTrace}) {
    if (_logger == null) _initConsoleLogger();

    StackTrace stack = stackTrace;
    if (stack == null && object is Error) stack = object.stackTrace;

    if (message != null && object != null) {
      _logger.log(severity, "$message - ${object.toString()}", null, stack);
    } else if (message != null) {
      _logger.log(severity, message, null, stack);
    } else if (object != null) {
      _logger.log(severity, object.toString(), null, stack);
    }
  }

  static Future<void> initLogger() async {
    // Skip <Info logs
    if (kDebugMode) {
      Logger.root.level = Level.ALL;
    } else {
      Logger.root.level = Level.INFO;
    }
    // switch (Constants.env) {
    //   case Environment.QA:
    //   case Environment.PROD:
    //     await Flogger._initRemoteLogger();
    //     break;
    // }
  }

  static _initConsoleLogger() {
    _logger = Logger(loggerName);
//    _logger.level = Level.ALL;
    _logger.onRecord.listen((record) {
      final message = _formatMessage(record);
      log(message);
    });
    debug("Logger initialized.");
  }

  // static Future<void> _initRemoteLogger() async {
  //   _logger = Logger(loggerName);
  //   final info = await DeviceInfoPlugin().iosInfo;
  //   await FlutterPaperTrail.initLogger(
  //     hostName: Constants.LOGGING_URL,
  //     programName: Constants.APP_NAME,
  //     port: Constants.LOGGING_PORT,
  //     machineName: info?.model,
  //   );
  //
  //   _logger.onRecord.listen((record) {
  //     final message = _formatMessage(record);
  //     log(message);
  //     PaperTrailUtils.logRecord(message, record.level);
  //   });
  // }

  static String _formatMessage(LogRecord record) {
    var message =
        '${record.loggerName}: ${record.level.name}: ${record.message}';

    if (record.stackTrace != null) message += '${record.stackTrace}';

    return message;
  }
}
