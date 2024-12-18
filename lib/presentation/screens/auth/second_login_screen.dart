import 'dart:io';

import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/shared/info_chinchin_popup.dart';
import 'package:f_bapp/common/widgets/shared/terms_condition_button.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/helpers/base64_coder.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/auth/login_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/shared/error_box.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class SecondLoginScreen extends StatefulWidget {
  const SecondLoginScreen({super.key});

  @override
  State<SecondLoginScreen> createState() => _SecondLoginScreenState();
}

class _SecondLoginScreenState extends State<SecondLoginScreen> {
  final secondLoginForm = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final loginProvider = context.watch<LoginProvider>();
    final textTheme = Theme.of(context).textTheme;
    final textStyle = Theme.of(context).textTheme;

    //  Funcion regresar
    _onBack() {
      loginProvider.disposeValues();
      Navigator.pop(context);
      return true;
    }

    return WillPopScope(
      onWillPop: () async {
        loginProvider.disposeValues();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _onBack();
            }, 
            icon: const Icon(Icons.arrow_back),
            ),
          
          title: GestureDetector(
            onTap: () {
              _onBack();
            },
            child: const Text('Iniciar sesión'),
          ),
        ),

        body: Center(
          child: SingleChildScrollView(

            child: Form(
              key: secondLoginForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  //Logo de business
                  SvgPicture.asset(
                    '${DataConstant.imagesChinchin}/chinchin-logo-business-base.svg',
                    width: 220, 
                    fit: BoxFit.contain, 
                  ),

                  const SizedBox(height: 30),


                  Text(
                    'Iniciar Sesión',
                    style: textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.isDarkModeEnabled ? primaryColor : null
                    ),
                  ),
            
                  const SizedBox(
                    height: 20,
                  ),
            
                  CustomTextFormField(
                    controller: passwordController,
                    paddingV: 20,
                    paddingH: 25,
                    inputType: TextInputType.visiblePassword,
                    maxLength: 20,
                    obscureText: loginProvider.isPasswordObscure,
                    label: 'Contraseña *',
                    hintText: 'Ej: pagoServicios01',
                    onChanged: (val) => loginProvider.password = val,
                    suffixIcon: IconButton(
                    icon: loginProvider.isPasswordObscure ? const Icon(Icons.visibility_off,)
                    : const Icon(Icons.visibility,),
                    onPressed: () => loginProvider.updatePasswordObscure(!loginProvider.isPasswordObscure,),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
            
                      if (value.contains(' ')) {
                        return 'El campo no permite espacios';
                      }
            
                      if (value.length < 8) {
                        return 'Mínimo 8 caracteres';
                      }
            
                      if (value.length > 20) {
                        return 'Máximo 20 caracteres';
                      }
            
                      return null;
                    },
                  ),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: CustomButton(
                      provider: loginProvider,
                      title: "Ingresar", 
                      isPrimaryColor: true, 
                      isOutline: false, 
                      paddingH: 0,
                      onTap: () async{
                        if (secondLoginForm.currentState!.validate()) {
                          //Se crea el objeto con el nombre del usuario y su contraseña
                          final loginData = {
                            'member': loginProvider.userLogin!,
                            'password': Base64Encoder.encodeBase64(loginProvider.password!),
                          };

                          //Se realiza la peticion para iniciar sesion
                          final loginResp = await loginProvider.loginUser(loginData);
                    
                          if (loginProvider.statusCode != HttpStatus.ok) {
                          return;
                          }

                          //Se obtiene la lista de miembros
                          final memberResp = await userProvider.getMemberlist(loginProvider.userLogin!);
                          
                          loginProvider.disposeValues();
                          
                          if (!mounted) return;
                            
                          //Se indica que el usuario esta autenticado
                          context.read<SessionProvider>().authenticateUser();
                          final sessionProvider = context.read<SessionProvider>();
                    
                           final LocalAuthentication auth = LocalAuthentication();
                           // Variable que indica que el dispositivo Para verificar si hay autenticación local disponible en este dispositivo
                            var deviceHasBiometricOptions = await auth.canCheckBiometrics;
                            final bool isDeviceSupported = await auth.isDeviceSupported();
                    
                            // Si no tiene biometria le pongo el popup
                          if (!loginProvider.enabledBiometric &&
                              deviceHasBiometricOptions == true && isDeviceSupported == true) {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AppDialogs.biometricDialog(
                                context,
                                loginData,
                              ),
                            );
                          }

                        //Indico el primer elemento de la lista de miembros como la compañia seleccionada 
                        context.read<NavigationProvider>().updateCompany(userProvider.memberlist![0]['idParentRelation'].toString());

                         //Inicia el temporizador de la sesion  
                        sessionProvider.startSessionTimer(150000);
                    
                          if (!mounted) return;

                          //Se navega hasta la vista home
                          Navigator.pushReplacementNamed(
                              context,
                              homeScreen,
                            );
                          
                                
                          loginProvider.resetValues();
                                
                            
                        }
                      }
                      ),
                  ),

                    ErrorBox(provider: loginProvider, paddingH: 25),

                    CustomButton(
                    provider:loginProvider ,
                    title: '¿Olvidó su contraseña?', 
                    isPrimaryColor: false, 
                    isOutline: false, 
                    isText: true,
                    styleText: textStyle.labelLarge,
                    paddingH: 40,
                    paddingV: 10,
                    height: 35,
                    onTap: () {})
                   
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