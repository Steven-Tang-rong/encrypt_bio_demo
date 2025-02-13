import 'package:encrypt_bio_demo/right_to_left_page_route.dart';
import 'package:encrypt_bio_demo/services/biometric_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'neumorphic_button.dart';

class SuccessPage extends StatefulWidget {
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final _biometricService = BiometricService();

  bool _isBiometricEnable = false;

  Future<void> _initBiometricState() async {
    bool isEnabled = await _biometricService.biometricEnabled();

    setState(() {
      _isBiometricEnable = isEnabled;
    });
  }

  Future<void> _enableBiometricState() async {
    _isBiometricEnable = await _biometricService.openBiometrics();
  }

  Future<void> _disableBiometricState() async {
    _isBiometricEnable = await _biometricService.disableBiometrics();
  }

  @override
  void initState() {
    super.initState();

    _initBiometricState();
    initBio();
  }

  Future<void> initBio() async {
    await Future.delayed(Duration(microseconds: 1000));
    print('ST - _isBiometricEnable = $_isBiometricEnable ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.teal,
                size: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                ' 登入成功！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 24),
              NeumorphicButton(
                child: const Text("返回"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NeumorphicButton(
                  child: _isBiometricEnable == false
                      ? const Text(
                          "開啟生物辨識",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          "關閉生物辨識",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                  onPressed: () {
                    if (_isBiometricEnable!) {
                      _disableBiometricState();
                    } else {
                      _enableBiometricState();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
