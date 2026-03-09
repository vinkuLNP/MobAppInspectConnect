import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceInfoHelper {
  static Future<String> getDeviceType() async {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  static Future<String> getDeviceToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      log('[FCM] FCM token: $token');
      return token ?? "";
    } on FirebaseException catch (e, s) {
      if (e.code == 'apns-token-not-set') {
        log('[FCM] APNS token not set yet, using placeholder.\n$e\n$s');

        return 'apns-token-pending-ios';
      }

      log(
        '[FCM] FirebaseException in getDeviceToken: ${e.code} - ${e.message}\n$s',
      );
      return '';
    } catch (e) {
      log('[FCM] FCM ERRROR: $e');

      return "";
    }
  }
}
