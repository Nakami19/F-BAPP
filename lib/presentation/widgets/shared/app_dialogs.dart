import 'dart:convert';

import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/infrastructure/services/storage_service_impl.dart';
import 'package:f_bapp/presentation/providers/app_providers.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:provider/provider.dart';

class AppDialogs {
  static TextStyle fontStyle = const TextStyle(fontSize: 18);
  
    /// Cerrar sesión
    static logoutDialog(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final textStyle = Theme.of(context).textTheme.labelMedium;

    return AlertDialog(
      backgroundColor:
          themeProvider.isDarkModeEnabled ? darkColor : primaryScaffoldColor,
      title: Text(
        'Cerrar sesión',
        style: fontStyle,
        textAlign: TextAlign.center,
      ),
      content: const Text(
        '¿Estás seguro que deseas cerrar tu sesión?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomButton(
                    title: 'CANCELAR',
                    isPrimaryColor: false,
                    isOutline: false,
                    isText: true,
                    width: 90,
                    paddingH: 0,
                    height: 50,
                    styleText: textStyle!.copyWith(
                      color: Color.fromRGBO(252, 198, 20, 100),
                      fontSize: 12,
                    ),
                    styleTextButton: TextButton.styleFrom(
                      side: BorderSide(
                        color: Color.fromRGBO(
                            252, 198, 20, 100), // Cambia a tu color deseado
                        width: 2, // Grosor del borde
                      ),
                    ),
                    onTap: () {Navigator.pop(context);},
                    provider: GeneralProvider()),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomButton(
                    title: 'CONFIRMAR',
                    isPrimaryColor: true,
                    isOutline: false,
                    width: 90,
                    paddingH: 0,
                    height: 50,
                    onTap: () async {
                      
                      SecureStorageService()
                        ..deleteValue('userData')
                        ..deleteValue('timeExpiration');

                      AppProviders.disposeAllProviders(
                        context,
                      );

                      context.read<SessionProvider>().destroySession(
                            haveModalAction: false,
                          );

                      // context.read<SessionProvider>().cancelTimer(
                      //       haveModalAction: false,
                      //     );

                      
                      
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        firstLoginScreen,
                        (route) => false,
                      );

                      Snackbars.customSnackbar(
                        context,
                        title: '¡Vuelva Pronto!',
                        message: 'Su sesión ha sido cerrada exitosamente.',
                      );
                    },
                    styleText: textStyle!.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    provider: GeneralProvider()),
              ),
            ),
          ],
        ),
    
      ],
    );
  }

  /// Guardar datos para login con biometría.
  /// Toma los datos del login para iniciar sesion [data]
  static biometricDialog(BuildContext context, Map<String, dynamic> data) {
    final loginProvider = context.read<LoginProvider>();
    final themeProvider = context.read<ThemeProvider>();

    return AlertDialog(
      backgroundColor:
          themeProvider.isDarkModeEnabled ? darkColor : primaryScaffoldColor,
      title: Icon(
        Icons.fingerprint,
        size: 50,
        color: themeProvider.isDarkModeEnabled ? Colors.white : null,
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Puedes iniciar sesión con biometría',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Activa la biometría y úsala para inciar sesión más rápido.',
            textAlign: TextAlign.center,
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'CANCELAR',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        FilledButton(
          onPressed: () async {
            final LocalAuthentication auth = LocalAuthentication();

            try {
              final biometricResult = await auth.authenticate(
                localizedReason: 'Usa tu huella para iniciar sesión',
                options: const AuthenticationOptions(
                  biometricOnly: true,
                ),
                authMessages: const <AuthMessages>[
                  AndroidAuthMessages(
                    signInTitle: 'Autenticación biométrica requerida',
                    biometricHint: 'Verificar identidad',
                    cancelButton: 'Cancelar',
                  ),
                ],
              );

              final keyValueStorageServicer = SecureStorageService();
              final normalStorage = StorageService();
              loginProvider.changeBiometricStatus(biometricResult);

              normalStorage.setKeyValue<String>(
                'enabledBiometric',
                biometricResult.toString(),
              );
              keyValueStorageServicer.setKeyValue(
                'userLoginData',
                json.encode(data),
              );

              Navigator.pop(context);
            } on PlatformException {
              Navigator.pop(context);
              Snackbars.notBiometricSnackbar(context);
            }
          },
          child: const Text(
            'ACTIVAR',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }



}