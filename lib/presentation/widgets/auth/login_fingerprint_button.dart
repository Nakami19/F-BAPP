import 'dart:convert';
import 'dart:io';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';


class FingerPrintAuthButton extends StatefulWidget {
  const FingerPrintAuthButton({
    super.key,
  });

  @override
  State<FingerPrintAuthButton> createState() => _FingerPrintAuthButtonState();
}

class _FingerPrintAuthButtonState extends State<FingerPrintAuthButton> {
  @override
  Widget build(BuildContext context) {
    final keyValueStorageServicer = SecureStorageService();
    final loginProvider = context.watch<LoginProvider>();
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
      //   width: double.infinity,
      //   height: 50,
      //   child: OutlinedButton(
      //     child: !loginProvider.isLoading
      //         ? const Icon(Icons.fingerprint)
      //         : Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               const SizedBox(
      //                 height: 20,
      //                 width: 20,
      //                 child: CircularProgressIndicator(
      //                   strokeWidth: 2,
      //                   color: primaryColor,
      //                 ),
      //               ),
      //               const SizedBox(
      //                 width: 10,
      //               ),
      //               Text(
      //                 'Cargando...',
      //                 style:
      //                     textStyle.bodyMedium!.copyWith(color: primaryColor),
      //               ),
      //             ],
      //           ),
      //     onPressed: () async {
      //       if (!loginProvider.isLoading) {
      //         final LocalAuthentication auth = LocalAuthentication();

      //         try {
      //           final biometricResult = await auth.authenticate(
      //             localizedReason: 'Usa tu huella para iniciar sesión',
      //             options: const AuthenticationOptions(
      //               biometricOnly: true,
      //             ),
      //             // authMessages: const <AuthMessages>[
      //             //   AndroidAuthMessages(
      //             //     signInTitle: 'Autenticación biométrica requerida',
      //             //     biometricHint: 'Verificar identidad',
      //             //     cancelButton: 'Cancelar',
      //             //   )
      //             // ],
      //           );

      //           if (biometricResult) {
      //             final biometricData = await keyValueStorageServicer.getValue(
      //               'userLoginData',
      //             );

      //             if (biometricData != '' && biometricData != null) {
      //               final decodedBiometricData = json.decode(biometricData);

      //               // Login con biometría
      //               final loginResp = await loginProvider
      //                   .login1(decodedBiometricData, isFromBiometric: true);

      //               if (loginProvider.statusCode == HttpStatus.ok) {
      //                 // llamo al metodo authenticateUser para declarar como true el valor de la autenticación
      //                 context.read<SessionProvider>().authenticateUser();

      //                 // PENDIENTE CON ESTO CAMBIAR COMO ANTES POR SI ACASO
      //                 final sessionProvider = context.read<SessionProvider>();

      //                 // Pongo el timer de la sesion
      //                 sessionProvider.startSessionTimer(
      //                   loginResp!.data!.timeExpiration,
      //                   // 15000,
      //                 );

                     
      //                   loginProvider.disposeValues();

      //                   // context.read<HomeProvider>().changeScreen(Views.Home);

                        

      //                   if (!mounted) return;

                        
                      
      //               }
      //             }
      //           }
      //         } on PlatformException {
      //           Snackbars.notBiometricSnackbar(context);
      //         }
      //       }
      //     },
      //   ),
      ),
    );
  }
}