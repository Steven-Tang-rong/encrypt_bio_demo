import 'package:encrypt_bio_demo/services/biometric_service.dart';
import 'package:encrypt_bio_demo/style/custom_button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum LoginState {
  initial,
  loading,
  success,
  error
}

class LoginError {
  final String message;
  final String? code;

  LoginError(this.message, {this.code});
}

class LoginViewModel extends ChangeNotifier {
  final _biometricService = BiometricService();

  // 控制器
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode idFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  // 狀態
  LoginState _state = LoginState.initial;
  LoginState get state => _state;

  // 錯誤信息
  LoginError? _error;
  LoginError? get error => _error;

  // 是否可以點擊登入按鈕
  bool _canLogin = false;
  bool get canLogin => _canLogin && _state != LoginState.loading;

  // 追蹤是否已經導航到成功頁面
  bool _hasNavigated = false;
  bool get hasNavigated => _hasNavigated;

  bool _isBiometricEnabled = false;
  bool get isBiometricEnabled => _isBiometricEnabled;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void setNavigated(bool value) {
    _hasNavigated = value;
    notifyListeners();
  }

  static const int minPasswordLength = 8;

  void resetState() {
    _state = LoginState.initial;
    _hasNavigated = false;
    _error = null;
    notifyListeners();
  }

  LoginViewModel() {
    idController.addListener(_validateInputs);
    passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final bool isValid = idController.text.isNotEmpty &&
        passwordController.text.length >= minPasswordLength;

    if (_canLogin != isValid) {
      _canLogin = isValid;
      // Reset state to initial when inputs change
      if (_state == LoginState.success) {
        _state = LoginState.initial;
      }
      notifyListeners();
    }
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> login() async {
    if (!_canLogin) return;

    try {
      _state = LoginState.loading;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      _state = LoginState.success;
      _error = null;

    } catch (e) {
      _state = LoginState.error;
      _error = LoginError('登入失敗：${e.toString()}');
    } finally {
      notifyListeners();
    }
  }

  Future<void> quickLogin(BuildContext context) async {
    //if (!_canLogin) return;

    try {
      _state = LoginState.success;
      _error = null;

    } catch (e) {
      _state = LoginState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkBiometricState() async {
    _isBiometricEnabled =
    await _biometricService.biometricEnabled();
  }

  Future<void> loginAuthenticate(BuildContext context) async {
    if (_isProcessing) return;
    _isProcessing = true;
    notifyListeners();

    await checkBiometricState();

    if (!context.mounted) return;

    if (!isBiometricEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
              "\n尚未開啟快速登入設定",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "PingFangTC",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
            ),
            actions: [
              ElevatedButton(
                style: CustomButtonStyle.purpleButtonStyle,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  '確定',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "PingFangTC",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                ),
              ),
            ],
          );
        },
      );

      _isProcessing = false;
      notifyListeners();
      return;
    }

    if (await _biometricService.authenticate()) {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);

      _isProcessing = false;
      EasyLoading.dismiss();

      if (!context.mounted) return;
      quickLogin(context);
    }
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}