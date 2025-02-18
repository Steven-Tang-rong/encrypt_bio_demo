import 'package:encrypt_bio_demo/provider/success_page_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../neumorphic_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuccessPageViewModel()..initBiometricState(),
      child: Scaffold(
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
                  child: Consumer<SuccessPageViewModel>(
                     builder: (context, viewModel, child) {
                       return NeumorphicButton(
                         child: viewModel.isBiometricEnable == false
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
                           viewModel.toggleBiometricState();
                         },
                       );
                     },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
