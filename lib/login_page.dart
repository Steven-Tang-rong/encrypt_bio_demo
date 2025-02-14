import 'package:encrypt_bio_demo/services/biometric_service.dart';
import 'package:encrypt_bio_demo/success_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginViewModel loginViewModel;
  final _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    // 在 initState 中初始化 ViewModel
    loginViewModel = LoginViewModel();
    loginViewModel.addListener(_handleLoginStateChange);

    initBiometricState();
  }

  Future<void> initBiometricState() async {
    loginViewModel.isBiometricEnabled =
        await _biometricService.biometricEnabled();
  }

  void _handleLoginStateChange() {
    if (loginViewModel.state == LoginState.success &&
        !loginViewModel.hasNavigated) {
      // 確保在下一幀執行導航
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToSuccess();
      });
    }
  }

  void _navigateToSuccess() {
    if (!mounted) return; // 確保 Widget 還在樹中

    Navigator.of(context)
        .push(
      CupertinoPageRoute(
        builder: (context) => SuccessPage(),
      ),
    )
        .then((_) {
      // 導航返回後重置狀態
      loginViewModel.resetState();
    });
  }

  Widget userPassWordInput(BuildContext context) {
    return TextField(
      obscureText: true,
      style: const TextStyle(fontSize: 14, color: Color(0xff1d747b)),
      decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isCollapsed: true,
          //自定義高用
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          //自定義高用
          hintText: '請輸入密碼',
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12.0)))),
      //controller: passWordTextController,
      onEditingComplete: () {
        hideKeyboard(context);
      },
      onChanged: (String content) {
        print('ST - 輸入密碼');
      },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  Future<void> loginAuthenticate() async {
    if (loginViewModel.isBiometricEnabled == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("尚未開啟快速登入設定"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("確定"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (await _biometricService.authenticate()) {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
      //TODO quickLogin;
      print('ST - quickLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider<LoginViewModel>.value(
      value: loginViewModel,
      child: Consumer<LoginViewModel>(
        builder: (BuildContext context, loginViewModel, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: Colors.deepPurple,
                        size: 180.0,
                        semanticLabel: '管理員設置',
                      ),
                      Positioned(
                        top: 30,
                        right: 30,
                        left: 30,
                        child: Icon(
                          Icons.fingerprint,
                          color: Colors.deepPurple,
                          size: 48.0,
                          semanticLabel: '指紋辨識',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 0, 12),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: '帳號',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                                fontFamily: "PingFangTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                          ),
                          TextSpan(
                            text: ' :',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                                fontFamily: "PingFangTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          )
                        ]),
                      )),
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x33acacac),
                            offset: Offset(0, 0),
                            blurRadius: 32,
                            spreadRadius: 0)
                      ],
                      color: Colors.deepPurpleAccent),
                  child: TextField(
                    controller: loginViewModel.idController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isCollapsed: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      hintText: '請輸入賬號',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontFamily: "PingFangTC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    onEditingComplete: () =>
                        loginViewModel.hideKeyboard(context),
                  ),
                ),
                const SizedBox(height: 16),
                // 密碼輸入框
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: '密碼',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                                fontFamily: "PingFangTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0),
                          ),
                          TextSpan(
                            text: ' :',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                                fontFamily: "PingFangTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          )
                        ]),
                      )),
                ),
                TextField(
                  controller: loginViewModel.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    isCollapsed: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    hintText: '請輸入密碼',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "PingFangTC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  onEditingComplete: () => loginViewModel.hideKeyboard(context),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 登入按鈕
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.deepPurpleAccent.shade100; // 按下時的顏色
                            } else if (states.contains(WidgetState.disabled)) {
                              return Colors.white; // 禁用時的顏色
                            }
                            return Colors.white; // 預設顏色
                          }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white; // 按下時的顏色
                            } else if (states.contains(WidgetState.disabled)) {
                              return Colors.grey; // 禁用時的顏色
                            } else if (states.contains(WidgetState.hovered)) {
                              return Colors.orange; // 滑鼠懸停時的顏色
                            }
                            return Colors.deepPurple; // 預設顏色
                          }),
                        ),
                        onPressed: loginViewModel.canLogin
                            ? loginViewModel.login
                            : null,
                        child: loginViewModel.state == LoginState.loading
                            ? const CircularProgressIndicator()
                            : const Text('登入'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.deepPurpleAccent.shade100; // 按下時的顏色
                            } else if (states.contains(WidgetState.disabled)) {
                              return Colors.white; // 禁用時的顏色
                            }
                            return Colors.deepPurple; // 預設顏色
                          }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white; // 按下時的顏色
                            } else if (states.contains(WidgetState.disabled)) {
                              return Colors.grey; // 禁用時的顏色
                            } else if (states.contains(WidgetState.hovered)) {
                              return Colors.orange; // 滑鼠懸停時的顏色
                            }
                            return Colors.white; // 預設顏色
                          }),
                        ),
                        onPressed: () {
                          print('快速登入');
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                              size: 24.0,
                              semanticLabel: '指紋辨識',
                            ),
                            SizedBox(width: 8),
                            Text(
                              '快速登入',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "PingFangTC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 錯誤提示
                if (loginViewModel.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loginViewModel.error!.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ]),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          );
        },
      ),
    );
  }
}
