import 'dart:convert';
import 'dart:io';

import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/constants.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/shared/app_banner_version.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/flavors.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:f_bapp/infrastructure/shared/storage_service_impl.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/common/widgets/shared/error_box.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/auth/login_fingerprint_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/shared/info_chinchin_popup.dart';
import '../../../common/widgets/shared/terms_condition_button.dart';
import '../../../common/providers/theme_provider.dart';

class FirstLoginScreen extends StatefulWidget {
  const FirstLoginScreen({super.key});

  @override
  State<FirstLoginScreen> createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {
  final userLoginController = TextEditingController();
  final firstLoginForm = GlobalKey<FormState>();
  dynamic decodedBiometricData;
  dynamic decodedUserData;
  bool existBiometricData = false;
  bool existUserData = false;
  bool enabledBiometric = false;
  bool useAnotherAccount = false;
  FocusNode _focusNode = FocusNode();
  final normalStorage = StorageService();
  final storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();

    final loginProvider = context.read<LoginProvider>();


    Future.microtask(() async {
      await _clearStorageOnFirstInstall();
      //Verifica si la biometria esta habilitada
      // var enabledBiometricValue = await normalStorage.getValue<String>('enabledBiometric');
      var enabledBiometricValue = await normalStorage.getValue<String>('enabledBiometric') ?? "false";

      print(enabledBiometricValue);
      //Datos del usuario
      var encodedUserData = await normalStorage.getValue<String>('userCompleteName');

      //Si hay datos almacenados indica que los datos existen y los decodifica 
      if (encodedUserData != '' && encodedUserData != null) {
        existUserData = true;
        decodedUserData = json.decode(encodedUserData);
      }

      //Indicar si la biometria esta habilitada
      enabledBiometric = enabledBiometricValue == "true" ? true : false;

      loginProvider.changeBiometricStatus(enabledBiometric);


      // Voy a obtener la biometria

      final biometricData = await storageService.getValue('userLoginData');

      // Si existe la biometria entonces la decodifico
      if (biometricData != '' &&
          biometricData != null &&
          enabledBiometric == true) {
            setState(() {
              existBiometricData = true;
        decodedBiometricData = json.decode(biometricData);
            });
      } else {
        existBiometricData = false;
      }

      //Se establece que el navbar debe mostrarse
    final navProvider = context.read<NavigationProvider>();
    navProvider.updateShowNavBar(true);
    });
  }

  @override
  void dispose() {
    userLoginController.dispose();

    super.dispose();
  }

  Future<void> _clearStorageOnFirstInstall() async {
  final isFirstInstallKey = 'isFirstInstall';
  
  // Comprobar si es la primera instalación
  final prefs = await normalStorage.getSharedPrefs();
  final isFirstInstall = prefs.getBool(isFirstInstallKey) ?? true;

  if (isFirstInstall) {
   
    await normalStorage.deleteAll();
    // Eliminar todos los datos de FlutterSecureStorage
    await storageService.deleteAll();

    // Marcar que ya no es la primera instalación
    await prefs.setBool(isFirstInstallKey, false);

    print('Datos borrados al instalar la aplicación por primera vez.');
  }
}

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final utilsProvider = context.read<UtilsProvider>();
    final textTheme = Theme.of(context).textTheme.titleLarge;
    final textStyle = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        userLoginController.clear();
        loginProvider.disposeValues();
        loginProvider.isActionWithUser(true);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          environment: FlavorConfig.flavorValues.environmentName,
          buildNumber: Constants.buildNumber!,
          version: Constants.appVersion!,
        ),

        body: Center(
          child: SingleChildScrollView(

            child: Form(
              key: firstLoginForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  //Logo business
                  SvgPicture.asset(
                    '${DataConstant.imagesChinchin}/chinchin-logo-business-base.svg',
                    width: 220,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 30),

                  // si no hay biometria o se utiliza una cuenta diferente
                  if (enabledBiometric == false &&
                          existBiometricData == false ||
                      useAnotherAccount)
                    Text(
                      'Iniciar sesión',
                      style: textTheme!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: themeProvider.isDarkModeEnabled
                              ? primaryColor
                              : null),
                    ),

                  // Tengo biometria texto con el username
                  if (enabledBiometric == true &&
                      existBiometricData == true &&
                      existUserData == false &&
                      useAnotherAccount == false)
                    Text(
                      '¡Hola, ${decodedBiometricData['member']}!',
                      textAlign: TextAlign.center,
                      style: textTheme!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? primaryColor
                            : null,
                      ),
                    ),

                  // Tengo biometria texto con el nombre y apellido
                  if (enabledBiometric == true &&
                      existUserData == true &&
                      useAnotherAccount == false &&
                      decodedUserData != null &&
                      decodedUserData['personName'] != null &&
                      decodedUserData['personLastName'] != null)
                    Text(
                      '¡Hola, ${decodedUserData['personName'] == 'Usuario' && decodedUserData['personLastName'] == 'Chinchin' ? decodedBiometricData['member'] : '${utilsProvider.capitalize(decodedUserData['personName'])} ${utilsProvider.capitalize(decodedUserData['personLastName'])}'}!',
                      textAlign: TextAlign.center,
                      style: textTheme!.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? primaryColor
                            : null,
                      ),
                    ),

                  const SizedBox(
                    height: 20,
                  ),


                  if (loginProvider.actionWithUser) ...[
                    // No tengo biometria
                    if (enabledBiometric == false &&
                            existBiometricData == false ||
                        useAnotherAccount)
                      CustomTextFormField(
                        controller: userLoginController,
                        node: _focusNode,
                        paddingV: 20,
                        paddingH: 25,
                        inputType: TextInputType.text,
                        label: 'Usuario o correo electrónico *',
                        hintText: 'ej: Victor.45',
                        maxLength: 254,
                        onChanged: (val) => loginProvider.userLogin = val,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo requerido';
                          }

                          if (value.contains(' ')) {
                            return 'El campo no permite espacios';
                          }

                          if (value.length < 6) {
                            return 'Su usuario o correo debe tener mínimo 6 caracteres.';
                          }

                          if (value.length > 254) {
                            return 'Máximo 254 caracteres';
                          }

                          return null;
                        },
                      ),
                  ],

                  //No tengo biometria
                  if (enabledBiometric == false &&
                          existBiometricData == false ||
                      useAnotherAccount) 
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: CustomButton(
                              provider: loginProvider,
                              title: 'Siguiente',
                              isPrimaryColor: true,
                              isOutline: false,
                              paddingH: 0,
                              onTap: () async {
                                if (firstLoginForm.currentState!.validate()) {
                                  loginProvider.disposeValues();
                                  final verifyUserResp = await loginProvider
                                      .verifyUser(userLoginController.text);
                          
                                  if (loginProvider.statusCode != HttpStatus.ok) {
                                    return;
                                  }
                          
                                  if (loginProvider.existUser == true) {
                                    Navigator.pushNamed(
                                      context,
                                      secondLoginScreen,
                                    );
                                  }
                                } else {
                                  print('Formulario inválido');
                                }
                              }),
                        ),

                            CustomButton(
                          provider:
                              Provider.of<LoginProvider>(context, listen: false),
                          title: '¿Olvidó su contraseña?',
                          isPrimaryColor: false,
                          isOutline: false,
                          isText: true,
                          styleText: textStyle.labelLarge,
                          paddingV: 5,
                          height: 35,
                          paddingH: 70,
                          onTap: () {}),
                      ],
                    ),
                    
                    //tengo biometria y vengo de otra cuenta
                    if (enabledBiometric == true &&
                          existBiometricData == true &&
                      useAnotherAccount) 
                      TextButton(
                      style: TextButton.styleFrom(
                        elevation: 0,
                        overlayColor: Colors.transparent
                      ),  
                      onPressed: () {
                        setState(() {
                          useAnotherAccount = false;

                          // Marco que si vengo desde otra cuenta nueva
                          loginProvider.changeIsFromAnotherAccount(false);
                        });
                      },
                      child: Text(
                        'Volver a biometría',
                        style: textStyle.labelLarge,
                      ),
                    ),

                  //tengo biometria y no vengo de otra cuenta
                  if (enabledBiometric && useAnotherAccount == false) ...[
                    const FingerPrintAuthButton()
                  ],

                  ErrorBox(
                    provider: loginProvider,
                    paddingH: 25,
                  ),
                

                //si tiene biometria y no viene de otra cuenta
                  if (enabledBiometric && 
                  existBiometricData && 
                  !useAnotherAccount)
                    TextButton(
                      style: TextButton.styleFrom(
                        elevation: 0,
                        overlayColor: Colors.transparent
                      ),
                      onPressed: () {
                        setState(() {
                          useAnotherAccount = true;

                          // Marco que si vengo desde otra cuenta nueva
                          loginProvider.changeIsFromAnotherAccount(true);
                        });
                      },
                      child: Text(
                        'No es mi cuenta',
                        style: textStyle.labelLarge,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: themeProvider.isDarkModeEnabled
                  ? darkColor
                  : primaryScaffoldColor,
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 15),
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  Icono info con popup chinchin
                  InfoChinchinPopup(),

                  // Terminos y conidiciones
                  TermsConditionsButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
