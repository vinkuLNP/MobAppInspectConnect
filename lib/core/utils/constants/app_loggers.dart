import 'dart:developer';

class AppLogger {
  static void info(String tag, String message) {
    log('ℹ️ [$tag] $message');
  }

  static void success(String tag, String message) {
    log('✅ [$tag] $message');
  }

  static void warning(String tag, String message) {
    log('⚠️ [$tag] $message');
  }

  static void error(String tag, Object error, [StackTrace? stack]) {
    log('❌ [$tag] $error', stackTrace: stack);
  }
}
