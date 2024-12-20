import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/buttons/loading_button_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../assets/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final GeneralProvider provider;
  final bool isPrimaryColor;
  final bool isOutline;
  final bool isText;
  final double? paddingH;
  final double? paddingV;
  final double? height;
  final double? width;
  final double borderRadius = borderRadiusValue;
  final ButtonStyle? styleTextButton;
  final TextStyle? styleText;
  final Color? colorFilledButton;
  final IconData? icon;
  final Color? iconColor;

  const CustomButton({
    super.key,
    required this.title,
    required this.isPrimaryColor,
    required this.isOutline,
    required this.onTap,
    required this.provider,
    this.paddingH,
    this.paddingV,
    this.height,
    this.width,
    this.isText = false,
    this.styleTextButton,
    this.styleText,
    this.colorFilledButton,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingH ?? 5,
        vertical: paddingV ?? 5,
      ),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 55,

        //Se verifica si el boton debe ser outline o text, por default sera filled
        child: isText
            ? TextButton(
                style: styleTextButton ?? styleTextButton,
                onPressed: !provider.isLoading ? () => onTap() : null,
                child: Text(
                  title,
                  style: styleText ?? styleText,
                ),
              )
            : isOutline
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      side: BorderSide(
                        color: isPrimaryColor ? primaryColor : secondaryColor,
                      ),
                      foregroundColor:
                          isPrimaryColor ? primaryColor : secondaryColor,
                    ),
                    onPressed: !provider.isLoading ? () => onTap() : null,
                    child: LoadingButtonText(
                      text: title,
                      provider: provider,
                      styleText: styleText,
                      icon: icon,
                      iconColor: iconColor,
                    ),
                  )
                : FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: isPrimaryColor
                          ? primaryColor
                          : (colorFilledButton ?? secondaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    onPressed: !provider.isLoading ? () => onTap() : null,
                    child: LoadingButtonText(
                      text: title,
                      provider: provider,
                      styleText: styleText,
                      icon: icon,
                      iconColor: iconColor,
                    ),
                  ),
      ),
    );
  }
}
