import 'package:encrypt_bio_demo/services/biometric_service.dart';
import 'package:flutter/material.dart';

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

  void setNavigated(bool value) {
    _hasNavigated = value;
    notifyListeners();
  }

  // 密碼長度限制
  static const int minPasswordLength = 8;

  // 替換原有的 initState 方法
  void resetState() {
    _state = LoginState.initial;
    _hasNavigated = false;
    _error = null;
    notifyListeners();
  }

  // 構造函數
  LoginViewModel() {
    // 監聽文本變化
    idController.addListener(_validateInputs);
    passwordController.addListener(_validateInputs);
    print('ST - LoginViewModel addListener');
  }

  // 驗證輸入
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
    print('ST - LoginViewModel _validateInputs');
  }

  // 隱藏鍵盤
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  // 執行登入
  Future<void> login() async {
    if (!_canLogin) return;

    try {
      _state = LoginState.loading;
      //_hasNavigated = false; // Reset navigation flag when starting new login
      notifyListeners();

      // TODO: 實現實際的登入邏輯
      await Future.delayed(const Duration(seconds: 1)); // 模擬網絡請求

      // 假設登入成功
      _state = LoginState.success;
      _error = null;

    } catch (e) {
      _state = LoginState.error;
      _error = LoginError('登入失敗：${e.toString()}');
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}