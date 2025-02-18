import 'package:flutter/material.dart';

extension HideKeyboard on BuildContext {
  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus ) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}