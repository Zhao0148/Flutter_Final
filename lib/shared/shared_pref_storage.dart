import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StorageHelper {
  static const String deviceIdKey = 'device_id';
  static const String sessionIdKey = 'session_id';

  static Future<void> saveDeviceId(String deviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(deviceIdKey, deviceId);
      if (kDebugMode) {
        print('Device id saved: $deviceId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error saving device id: $error');
      }
    }
  }

  static Future<String?> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString(deviceIdKey);
      if (kDebugMode) {
        print('Retrieved device id: $deviceId');
      }
      return deviceId;
    } catch (error) {
      if (kDebugMode) {
        print('Error getting device id: $error');
      }
      return null;
    }
  }

  static Future<void> saveSessionId(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(sessionIdKey, sessionId);
      if (kDebugMode) {
        print('Session id saved: $sessionId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error saving session id: $error');
      }
    }
  }

  static Future<String?> getSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString(sessionIdKey);
      if (kDebugMode) {
        print('Retrieved session id: $sessionId');
      }
      return sessionId;
    } catch (error) {
      if (kDebugMode) {
        print('Error getting session id: $error');
      }
      return null;
    }
  }

  static Future<void> clearSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(sessionIdKey);
      if (kDebugMode) {
        print('Session id cleared');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error clearing session id: $error');
      }
    }
  }
}
