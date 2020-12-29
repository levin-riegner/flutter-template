import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';

class Flogger {
  static Logger _logger = Logger("App");

  Flogger._();

  // region Log methods
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

  static registerListener(void onRecord(Tuple2<String, Level> onRecord)) {
    _logger.onRecord.map(_formatLogRecord).listen(onRecord);
  }

  static Tuple2<String, Level> _formatLogRecord(LogRecord record) {
    var message =
        '${record.loggerName}: ${record.level.name}: ${record.message}';
    if (record.stackTrace != null) message += '${record.stackTrace}';
    return Tuple2(message, record.level);
  }
}
