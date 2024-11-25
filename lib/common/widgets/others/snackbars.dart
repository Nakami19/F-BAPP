import 'package:another_flushbar/flushbar.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Snackbars {
  /// Se muestra cuando el dispositivo no soporta biometría para el inicio de sesión
  static notBiometricSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    const snakback = SnackBar(
      content: Text('No ha sido posible iniciar sesión'),
      showCloseIcon: true,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snakback);
  }

  static customSnackbar(
    BuildContext context, {
    String? title,
    required String message,
    bool isLightTheme = true,
  }) async {
    Flushbar(
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(BorderRadiusValue),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: isLightTheme ? primaryScaffoldColor : containerColor,
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      titleColor: isLightTheme ? Colors.black : Colors.white,
      message: message,
      messageColor: isLightTheme ? Colors.black : Colors.white,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}