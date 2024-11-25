import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../assets/theme/app_theme.dart';

class TermsConditionsButton extends StatelessWidget {
  final String? route;
  const TermsConditionsButton({Key? key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final color = themeProvider.isDarkModeEnabled == true
        ? darkColor
        : primaryScaffoldColor;

    return Container(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(height: 1.5),
          TextButton(
            child: const Text(
              'Términos y condiciones',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () => (),
          ),
        ],
      ),
    );
  }
}