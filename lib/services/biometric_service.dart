import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  BiometricService._internal();

  static final BiometricService _instance = BiometricService._internal();

  factory BiometricService() => _instance;

  final LocalAuthentication _auth = LocalAuthentication();
  List<BiometricType> availableBiometrics = [];

  static const String _biometricEnableKey = 'BIOMETRIC_ENABLE';

  Future<bool> biometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    bool inEnabled = prefs.getBool(_biometricEnableKey) ?? false;

    return inEnabled;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: '請使用生物辨識進行身分驗證',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('生物辨識驗證時發生錯誤: $e');
      return false;
    }
  }

  Future<bool> openBiometrics() async {
    try {
      final bool authenticated = await authenticate();
      if (!authenticated) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnableKey, true);

      return true;
    } catch (e) {
      //TODO show error dialog
      return false;
    }
  }

  Future<bool> disableBiometrics() async {
    try {
      final bool authenticated = await authenticate();
      if (!authenticated) return true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnableKey, false);

      return false;
    } catch (e) {
      //TODO show error dialog
      return true;
    }
  }

  Future<void> openBiometricSettings() async {
    if (Platform.isIOS) {
      await AppSettings.openAppSettings(type: AppSettingsType.security);
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 29) {
        //TODO
        const platform = MethodChannel('com.example.app/settings');
        try {
          await platform.invokeMethod('openBiometricSettings');
        } catch (e) {
          await AppSettings.openAppSettings(type: AppSettingsType.security);
        }
      } else {
        await AppSettings.openAppSettings(type: AppSettingsType.security);
      }
    }
  }
}
