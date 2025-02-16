import 'package:flutter/material.dart';

class CustomButtonStyle {


  static final ButtonStyle normalButtonStyle = ButtonStyle(
    backgroundColor:
    WidgetStateProperty.resolveWith<Color>(
            (states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors
                .deepPurpleAccent.shade100; // 按下時的顏色
          } else if (states
              .contains(WidgetState.disabled)) {
            return Colors.white; // 禁用時的顏色
          }
          return Colors.white; // 預設顏色
        }),
    foregroundColor:
    WidgetStateProperty.resolveWith<Color>(
            (states) {
          if (states
              .contains(MaterialState.pressed)) {
            return Colors.white; // 按下時的顏色
          } else if (states
              .contains(WidgetState.disabled)) {
            return Colors.grey; // 禁用時的顏色
          } else if (states
              .contains(WidgetState.hovered)) {
            return Colors.orange; // 滑鼠懸停時的顏色
          }
          return Colors.deepPurple; // 預設顏色
        }),
  );

  static final ButtonStyle purpleButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.deepPurpleAccent.shade100; // 按下時的顏色
      } else if (states.contains(MaterialState.disabled)) {
        return Colors.white; // 禁用時的顏色
      }
      return Colors.deepPurple; // 預設顏色
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.white; // 按下時的顏色
      } else if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // 禁用時的顏色
      } else if (states.contains(MaterialState.hovered)) {
        return Colors.orange; // 滑鼠懸停時的顏色
      }
      return Colors.white; // 預設顏色
    }),
  );
}