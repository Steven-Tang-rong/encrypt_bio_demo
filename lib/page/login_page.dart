import 'package:encrypt_bio_demo/style/custom_button_style.dart';
import 'package:encrypt_bio_demo/page/success_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    loginViewModel = LoginViewModel();
    loginViewModel.addListener(_handleLoginStateChange);

    loginViewModel.initBiometricState();
  }

  void _handleLoginStateChange() {
    if (loginViewModel.state == LoginState.success &&
        !loginViewModel.hasNavigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToSuccess();
      });
    }
  }

  void _navigateToSuccess() {
    if (!mounted) return;

    Navigator.of(context)
        .push(
      CupertinoPageRoute(
        builder: (context) => const SuccessPage(),
      ),
    )
        .then((_) {
      loginViewModel.resetState();
    });
  }

  Widget userPassWordInput(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      style: const TextStyle(fontSize: 14, color: Color(0xff1d747b)),
      decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: '請輸入密碼',
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12.0)))),
      //controller: passWordTextController,
      onEditingComplete: () {
        loginViewModel.hideKeyboard(context);
      },
      onChanged: (String content) {
        print('ST - 輸入密碼');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: loginViewModel,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Consumer<LoginViewModel>(
          builder: (BuildContext context, loginViewModel, Widget? child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
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
                              focusNode: loginViewModel.idFocus,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                hintText: '請輸入賬號',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "PingFangTC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                              onEditingComplete: () =>
                                  FocusScope.of(context).requestFocus(
                                      loginViewModel.passwordFocus)),
                        ),
                        const SizedBox(height: 16),
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
                          focusNode: loginViewModel.passwordFocus,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            hintText: '請輸入密碼',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontFamily: "PingFangTC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                          onEditingComplete: () =>
                              loginViewModel.hideKeyboard(context),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: CustomButtonStyle.normalButtonStyle,
                                onPressed: loginViewModel.canLogin
                                    ? loginViewModel.login
                                    : null,
                                child:
                                    loginViewModel.state == LoginState.loading
                                        ? const CircularProgressIndicator()
                                        : const Text('登入'),
                              ),
                              ElevatedButton(
                                style: CustomButtonStyle.purpleButtonStyle,
                                onPressed: loginViewModel.isProcessing
                                    ? null
                                    : () {
                                        loginViewModel
                                            .loginAuthenticate(context);
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
              ),
              // This trailing comma makes auto-formatting nicer for build methods.
            );
          },
        ),
      ),
    );
  }
}
