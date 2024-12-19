import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../assets/theme/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.node,
    this.hintText,
    this.hintStyle,
    this.inputType,
    this.suffixIcon,
    this.preffixIcon,
    this.label,
    this.validator,
    this.errorMessage,
    this.obscureText=false,
    this.maxLength,
    this.readOnly,
    this.showCursor,
    this.autofocus,
    this.enabled,
    this.paddingV = 5,
    this.paddingH = 5,
    this.isPaddingZero = false,
    this.hasShadow = true,
    this.onChanged,
    this.onTap,
    this.onValue,
    });

  final TextEditingController controller;
  final FocusNode? node;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextInputType? inputType;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final String? label;
  final String? errorMessage;
  final bool obscureText;
  final int? maxLength;
  final double paddingV;
  final double paddingH;
  final bool? readOnly;
  final bool? showCursor;
  final bool? autofocus;
  final bool? enabled;
  final bool isPaddingZero;
  final bool hasShadow;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final ValueChanged<String>? onValue;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    
    return Padding(

      padding: isPaddingZero
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      
      child: TextFormField(
        // Configura el campo con las opciones proporcionadas.
          keyboardType: inputType ?? TextInputType.text,
          autofocus: autofocus ?? false,
          controller: controller,
          focusNode: node,
          readOnly: readOnly ?? false,
          showCursor: showCursor ?? true,
          obscureText: obscureText,
          maxLength: maxLength,
          onChanged: onChanged,
          validator: validator,

        //Estilo del campo
          decoration: InputDecoration(
            contentPadding:const EdgeInsets.symmetric(horizontal: 23, vertical: 13),
            fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              counterText: '',
              prefixIcon: preffixIcon ?? null,
              suffixIcon: suffixIcon,
              isDense: true,

              label: label != null
                  ? Text(
                      label!,
                      maxLines: 1,
                      
                    )
                  : null,

              hintText: enabled == true ? hintText : null,
              hintStyle: hintStyle?? const TextStyle(
                color: hintTextColor,
              ),

              errorText: errorMessage,
              focusColor: colors.primary,

              // Bordes según el estado del campo.
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
              ),

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: const BorderSide(
                  color: hintTextColor,
                  width: 2,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: const BorderSide(
                  color: errorColor,
                  width: 2,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: const BorderSide(
                  color: errorColor,
                  width: 2,
                ),
              ),
            ),

          onTap: () {
              //Oculta el teclado en dispositivos iOS si el tipo es numérico.
              if (inputType == TextInputType.number &&
                  Theme.of(context).platform == TargetPlatform.iOS) {
                  FocusScope.of(context).unfocus();
              }

              if (node != null) {
                FocusScope.of(context).requestFocus(node);
                }

              //Se ejecuta la funcion onTap si fue proporcionada
              if (onTap != null) {
                onTap!();
              }
            },
          onFieldSubmitted: onValue,
        ),
    );
  }
}