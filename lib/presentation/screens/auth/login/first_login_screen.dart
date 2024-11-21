import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../common/widgets/others/info_chinchin_popup.dart';
import '../../../../common/widgets/others/tems_condition_button.dart';
import '../../../providers/shared/theme_provider.dart';

class FirstLoginScreen extends StatefulWidget {
  const FirstLoginScreen({super.key});

  @override
  State<FirstLoginScreen> createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {

  final userLoginController = TextEditingController();
  final firstLoginForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final textTheme = Theme.of(context).textTheme.titleLarge;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Form(
          key: firstLoginForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                '${DataConstant.images}/chinchin-logo-business-black.png',
                width: 220, 
                fit: BoxFit.contain, 
              ),
              const SizedBox(height: 30),
              Text(
                'Iniciar sesión',
                style: textTheme!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: themeProvider.isDarkModeEnabled ? primaryColor : null
                ),
              ),
              CustomTextFormField(
                controller: userLoginController,
                paddingV: 20,
                paddingH: 25,
                inputType: TextInputType.text,
                label: 'Usuario o correo electrónico *',
                hintText: 'ej: Victor.45',
                maxLength: 254,
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
              CustomButton(
                title: 'Siguiente', 
                isPrimaryColor: true, 
                isOutline: false, 
                paddingH: 0,
                onTap: () {
                  if (firstLoginForm.currentState!.validate()) {
                    print('Formulario válido');
                  } else {
                    print('Formulario inválido');
                  }
                }
                ),
              CustomButton(
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
    );
  }
}