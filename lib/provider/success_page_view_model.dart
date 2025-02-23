
import 'package:flutter/cupertino.dart';
import '../services/biometric_service.dart';

class SuccessPageViewModel extends ChangeNotifier {
  final BiometricService _biometricService = BiometricService();

  bool _isBiometricEnable = false;
  bool get isBiometricEnable => _isBiometricEnable;

  Future<void> initBiometricState() async {
    _isBiometricEnable = await _biometricService.biometricEnabled();

    notifyListeners();
  }

  Future<void> toggleBiometricState() async {
    if (_isBiometricEnable) {
      _isBiometricEnable = await _biometricService.disableBiometrics();
    } else {
      _isBiometricEnable = await _biometricService.openBiometrics();
    }
    notifyListeners();
  }

}