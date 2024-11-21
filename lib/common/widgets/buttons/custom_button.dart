import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/providers/shared/theme_provider.dart';
import '../../assets/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isPrimaryColor;
  final bool isOutline;
  final bool isText;
  final double? paddingH;
  final double? paddingV;
  final double? height; 
  final double borderRadius = BorderRadiusValue; 
  final ButtonStyle? styleTextButton;
  final TextStyle? styleText;

  const CustomButton({
    super.key,
    required this.title,
    required this.isPrimaryColor,
    required this.isOutline,
    required this.onTap,
    this.paddingH,
    this.paddingV,
    this.height,
    this.isText = false,
    this.styleTextButton,
    this.styleText,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final textTheme = Theme.of(context).textTheme.titleLarge;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingH ?? 20,
        vertical: paddingV ?? 10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: SizedBox(
          width: double.infinity,
          height: height?? 55,
          child: isText ?
                TextButton(
                  style: styleTextButton?? styleTextButton,
                  onPressed: onTap,
                  child: Text(title,
                  style: styleText??styleText,
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
                  onPressed: onTap,
                  child: Text(title,
                  style: textTheme!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),
                  ),
                  // onPressed: !provider.isLoading ? () => onTap() : null,
                  // child: LoadingButtonText(
                  //   text: title,
                  //   provider: provider,
                  // ),
                )
              : FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        isPrimaryColor ? primaryColor : secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  onPressed: onTap,
                  child: Text(title,
                  style: textTheme!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),
                  ),
                  // onPressed: !provider.isLoading ? () => onTap() : null,
                  // child: LoadingButtonText(
                  //   text: title,
                  //   provider: provider,
                  // ),
                ),
        ),
      ),
    );
  }
}