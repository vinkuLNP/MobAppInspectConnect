// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class DeviceHelper {
//   static Future<Map<String, String>> getDeviceInfo() async {
//     String deviceType = 'unknown';
//     String deviceToken = '';

//     final deviceInfo = DeviceInfoPlugin();

//     if (Platform.isAndroid) {
//       final info = await deviceInfo.androidInfo;
//       deviceType = 'android-${info.model}';
//     } else if (Platform.isIOS) {
//       final info = await deviceInfo.iosInfo;
//       deviceType = 'ios-${info.utsname.machine}';
//     } else if (Platform.isWindows) {
//       deviceType = 'windows';
//     } else if (Platform.isMacOS) {
//       deviceType = 'macos';
//     } else if (Platform.isLinux) {
//       deviceType = 'linux';
//     } else {
//       deviceType = 'web';
//     }

//     try {
//       // deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
      
//     } catch (_) {
//       deviceToken = 'no_fcm_token';
//     }

//     return {
//       'deviceType': deviceType,
//       'deviceToken': deviceToken,
//     };
//   }
// }



import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoHelper {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static final Uuid _uuid = const Uuid();

  /// Returns a deviceType (e.g., android, ios, windows, macos, linux)
  static Future<String> getDeviceType() async {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Generates or retrieves a unique token per device
  /// (You could later persist this locally if you want it to stay the same)
  static Future<String> getDeviceToken() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return '${androidInfo.id}_${_uuid.v4()}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return '${iosInfo.identifierForVendor}_${_uuid.v4()}';
      } else if (Platform.isWindows) {
        final winInfo = await _deviceInfoPlugin.windowsInfo;
        return '${winInfo.deviceId}_${_uuid.v4()}';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfoPlugin.macOsInfo;
        return '${macInfo.systemGUID}_${_uuid.v4()}';
      } else {
        return _uuid.v4();
      }
    } catch (e) {
      // fallback random token
      return _uuid.v4();
    }
  }


}
