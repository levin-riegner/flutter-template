import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:logger/logger.dart' as console_logger;

class Flogger {
  static const String loggerName = "App";

  static Logger _logger = Logger(loggerName);

  Flogger._();

  // region Log methods
  static d(String message, {Object object}) => debug(message, object: object);

  static debug(String message, {Object object}) {
    _log(message, severity: Level.CONFIG, object: object);
  }

  static i(String message, {Object object}) => info(message, object: object);

  static info(String message, {Object object}) {
    _log(message, severity: Level.INFO, object: object);
  }

  static w(String message, {Object object}) => warning(message, object: object);

  static warning(String message, {Object object}) {
    _log(message, severity: Level.WARNING, object: object);
  }

  static e(String message, {Object object, StackTrace stackTrace}) =>
      error(message, object: object, stackTrace: stackTrace);

  static error(String message, {Object object, StackTrace stackTrace}) {
    _log(message,
        severity: Level.SEVERE, object: object, stackTrace: stackTrace);
  }

  static _log(String message,
      {Level severity = Level.CONFIG, Object object, StackTrace stackTrace}) {
    if (_logger == null) {
      debugPrint("Logger is not initialized!");
      return;
    }

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

  // endregion

  static registerListener(void onRecord(FloggerRecord record)) {
    _logger.onRecord
        .map((e) => FloggerRecord.fromLogger(e, false))
        .listen(onRecord);
  }
}

class FloggerRecord {
  final String message;
  final Level level;
  final bool mightContainSensitiveData;

  FloggerRecord._(this.message, this.level, this.mightContainSensitiveData);

  factory FloggerRecord.fromLogger(
      LogRecord record, bool mightContainSensitiveData) {
    var message =
        '${record.loggerName}: ${record.level.name}: ${record.message}';
    if (record.stackTrace != null) message += '${record.stackTrace}';
    return FloggerRecord._(message, record.level, mightContainSensitiveData);
  }
}

extension LogLevel on Level {
  console_logger.Level toLoggerLevel() {
    if (this == Level.CONFIG) {
      return console_logger.Level.debug;
    } else if (this == Level.INFO) {
      return console_logger.Level.info;
    } else if (this == Level.WARNING) {
      return console_logger.Level.warning;
    } else if (this == Level.SEVERE || this == Level.SHOUT) {
      return console_logger.Level.error;
    } else {
      return console_logger.Level.debug;
    }
  }
}