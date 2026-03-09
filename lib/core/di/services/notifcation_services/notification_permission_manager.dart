import 'dart:io';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionManager {
  static Future<void> request() async {
    if (Platform.isAndroid) {
      await _requestAndroid();
    } else if (Platform.isIOS) {
      await _requestIOS();
    }
  }

  static Future<void> _requestAndroid() async {
    final status = await Permission.notification.status;
    log('🔔 [ANDROID] Notification status: $status');

    if (status.isGranted) {
      log('✅ [ANDROID] Notification permission granted');
      return;
    }

    if (status.isDenied) {
      final result = await Permission.notification.request();
      log('🔔 [ANDROID] Request result: $result');

      if (!result.isGranted) {
        log('❌ [ANDROID] User denied notification permission');
      }
    }

    if (status.isPermanentlyDenied) {
      log('⚠️ [ANDROID] Permanently denied → open settings');
      await openAppSettings();
    }
  }

  static Future<void> _requestIOS() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('🍎 [iOS] Permission status: ${settings.authorizationStatus}');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
