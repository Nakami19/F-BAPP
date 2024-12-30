import 'dart:convert';

import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/shared/snackbars.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:f_bapp/infrastructure/shared/storage_service_impl.dart';
import 'package:f_bapp/presentation/providers/app_providers.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:provider/provider.dart';

class AppDialogs {
  static TextStyle fontStyle = const TextStyle(fontSize: 18);

  // Revisar si estos se pueden pasar a common
  
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
                      fontSize: 10,
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
                    styleText: textStyle.copyWith(
                      color: Colors.white,
                      fontSize: 10,
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

//dialogo para reversar una order
static revertPopup(BuildContext context, Map<String, dynamic> order) {
    bool showFields = false; // Estado interno para mostrar o no los inputs.
    final sessionProvider = context.read<SessionProvider>();
    String? currentValue;
    TextEditingController documentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Texto
                  const Text(
                    'Se va a retornar los fondos a la cuenta correspondiente',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  const Text(
                    '¿Deseas intentar el reverso a una cédula distinta a la reportada por el cliente?',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  //botones de opciones 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: showFields,
                            onChanged: (value) {
                              setState(() {
                                showFields = value!;
                              });
                            },
                          ),
                          Text('Sí'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: showFields,
                            onChanged: (value) {
                              setState(() {
                                showFields = value!;
                              });
                            },
                          ),
                          Text('No'),
                        ],
                      ),
                    ],
                  ),

                  //Mostrar el input en caso de que se seleccione "Si"
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: showFields
                        ? Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [

                                  //Tipo de documento
                                  SizedBox(
                                    width: 80,
                                    child: Expanded(
                                      child: CustomDropdown(
                                          autoSelectFirst: true,
                                          options: sessionProvider
                                              .documentsType!
                                              .sublist(
                                                  1,
                                                  sessionProvider
                                                      .documentsType!.length),
                                          onChanged: (value) {
                                            setState(() {
                                              currentValue = value;
                                            });
                                          },
                                          selectedValue: currentValue,
                                          itemValueMapper: (option) =>
                                              option['documentTypeId']!,
                                          itemLabelMapper: (option) =>
                                              option['documentTypeName']!),
                                    ),
                                  ),

                                  //input
                                  Expanded(
                                      child: CustomTextFormField(
                                          controller: documentController,
                                          inputType: TextInputType.number,
                                          hintText: 'CI/RIF',
                                          enabled: true,
                                          maxLength: 8,
                                          validator: (value) {
                                            if (value != null && value != "") {
                                              if (value.length < 8) {
                                                return 'El formato no es válido ';
                                              }
                                            }

                                            return null;
                                          })),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          )
                        : SizedBox.shrink(key: ValueKey('empty')),
                  ),
                  SizedBox(height: 20),

                  //Botones de cancelar y aceptar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            styleText: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Color.fromRGBO(252, 198, 20, 100),
                                  fontSize: 12,
                                ),
                            styleTextButton: TextButton.styleFrom(
                              side: const BorderSide(
                                color: Color.fromRGBO(252, 198, 20, 100),
                                width: 2,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            provider: GeneralProvider(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomButton(
                            title: 'Aceptar',
                            isPrimaryColor: true,
                            isOutline: false,
                            width: 90,
                            paddingH: 0,
                            height: 50,
                            onTap: () {
                              final merchantProvider =
                                  context.read<MerchantProvider>();

                              merchantProvider.revertOrder(
                                  idDocumentType: currentValue,
                                  documentNumber: documentController.text,
                                  idOrder: order["idOrder"]);

                              Navigator.pop(context);
                            },
                            styleText: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                            provider: GeneralProvider(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}