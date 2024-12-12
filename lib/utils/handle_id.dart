import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter/foundation.dart';

class DeviceHelper {
  static Future<String> getDeviceId() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        const androidId = AndroidId();
        final id = await androidId.getId();
        return id ?? 'unknown_android';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios';
      }
      return 'unknown_platform';
    } catch (error) {
      if (kDebugMode) {
        print('Error getting device id: $error');
      }
      return 'error_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
