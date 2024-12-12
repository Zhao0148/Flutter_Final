
import 'package:flutter/foundation.dart';
import '../shared/shared_pref_storage.dart';
import 'handle_id.dart';

class AppState extends ChangeNotifier {
  String? _deviceId;
  String? _sessionId;

  String? get deviceId => _deviceId;
  String? get sessionId => _sessionId;

  AppState() {
    _initializeDeviceId();
  }

  Future<void> _initializeDeviceId() async {
    _deviceId = await StorageHelper.getDeviceId();

    if (_deviceId == null) {
      _deviceId = await DeviceHelper.getDeviceId();
      await StorageHelper.saveDeviceId(_deviceId!);
    }

    _sessionId = await StorageHelper.getSessionId();
    
    notifyListeners();
  }

  Future<void> setSessionId(String id) async {
    _sessionId = id;
    await StorageHelper.saveSessionId(id);
    notifyListeners();
    if (kDebugMode) {
      print('Sess id set: $id');
    }
  }

  Future<void> clearSession() async {
    _sessionId = null;
    await StorageHelper.clearSessionId();
    notifyListeners();
    if (kDebugMode) {
      print('Sess cleared');
    }
  }
}
