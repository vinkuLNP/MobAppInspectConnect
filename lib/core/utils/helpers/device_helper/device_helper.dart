import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoHelper {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static final Uuid _uuid = const Uuid();

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
      return _uuid.v4();
    }
  }


}
