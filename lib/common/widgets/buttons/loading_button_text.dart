import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:flutter/material.dart';

class LoadingButtonText extends StatelessWidget {
  final GeneralProvider provider;
  final String text;
  final TextStyle? styleText;
  final IconData? icon;
  final Color? iconColor; 

  const LoadingButtonText({
    super.key,
    required this.text,
    required this.provider,
    this.styleText,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 18);
    return provider.isLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Cargando...',
                style: textStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 15), // Espacio entre ícono y texto
              ],
              Flexible(
                child: Text(
                  text,
                  style: styleText ?? textStyle,
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible
                ),
              ),
            ],
          );
  }
}
