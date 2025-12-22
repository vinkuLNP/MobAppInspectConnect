import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inspect_connect/core/di/notifcation_services/app_notification.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("📩 Background message received: ${message.messageId}");
  await NotificationService.show(message);
}
