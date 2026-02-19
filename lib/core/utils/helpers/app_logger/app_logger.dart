import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static const bool _enableLogs = kDebugMode;

  static void debug(String message, {String tag = "DEBUG"}) {
    if (!_enableLogs) return;

    developer.log(
      message,
      name: tag,
    );
  }

  static void info(String message, {String tag = "INFO"}) {
    if (!_enableLogs) return;

    developer.log(
      message,
      name: tag,
    );
  }

  static void warning(String message, {String tag = "WARNING"}) {
    if (!_enableLogs) return;

    developer.log(
      message,
      name: tag,
    );
  }

  static void error(
    String message, {
    String tag = "ERROR",
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enableLogs) return;

    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
