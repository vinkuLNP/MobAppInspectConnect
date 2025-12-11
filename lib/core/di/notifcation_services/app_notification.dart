import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings settings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _fln.initialize(settings,
        onDidReceiveNotificationResponse: (response) {
      final payload = response.payload;
      if (payload != null) {
        handleRedirect(payload);
      }
    });

    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Shows important notifications',
        importance: Importance.max,
      );

      await _fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  static Future<void> show(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];
    final payload = message.data['redirectUrl'] ?? message.data['click_action'] ?? 'home';

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _fln.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static void handleRedirect(String redirectUrl) {
    print("Redirect to: $redirectUrl");
  }
}
