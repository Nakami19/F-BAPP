import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/providers/shared/theme_provider.dart';
import '../../assets/theme/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.hintText,
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
  final String? hintText;
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
    final themeProvider = context.read<ThemeProvider>();
    return Padding(
      padding: isPaddingZero ?? false
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: TextFormField(
          keyboardType: inputType ?? TextInputType.text,
          controller: controller,
          readOnly: readOnly ?? false,
          showCursor: showCursor ?? true,
          obscureText: obscureText,
          maxLength: maxLength,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              counterText: '',
              prefixIcon: preffixIcon ?? null,
              suffixIcon: suffixIcon,
              isDense: true,
              label: label != null
                  ? Text(
                      label!,
                      maxLines: 1,
                      // style: TextStyle(
                      //   color: enabled == true ? null : AppTheme.hintTextColor,
                      // ),
                    )
                  : null,
              hintText: enabled == true ? hintText : null,
              hintStyle: const TextStyle(
                color: AppTheme.hintTextColor,
              ),
              errorText: errorMessage,
              focusColor: colors.primary,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusValue),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusValue),
                borderSide: const BorderSide(
                  color: AppTheme.hintTextColor,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusValue),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusValue),
                borderSide: const BorderSide(
                  color: errorColor,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusValue),
                borderSide: const BorderSide(
                  color: errorColor,
                  width: 1.5,
                ),
              ),
            ),
          onTap: () {
              // Ocultar el teclado al tocar el campo de texto en iOS
              if (inputType == TextInputType.number &&
                  Theme.of(context).platform == TargetPlatform.iOS) {
                FocusScope.of(context).unfocus();
              }
        
              if (onTap != null) {
                onTap!();
              }
            },
          onFieldSubmitted: onValue,
        ),
    );
  }
}