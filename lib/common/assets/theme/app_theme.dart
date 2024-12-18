import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

part 'fonts.dart';
part 'light_theme.dart';
part 'dark_theme.dart';


// Border radius
const double borderRadiusValue = 30;

class AppTheme {
  final bool isDarkModeEnabled;

  late Color textColor;

  AppTheme({
    this.isDarkModeEnabled = false,
  });
  ThemeData theme(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    if (themeProvider.isDarkModeEnabled) {
      textColor = textColor;
      return themeDark(
        textColor,
      );
    } else {
      textColor = lightThemeTextColor;
      return themeLight();
    }
  }

  static ThemeData themeLight() {
    return themeDataLight(
      lightThemeTextColor,
    );
  }

  static ThemeData themeDark(
    primaryColor,
  ) {
    return themeDataDark(
      Colors.white,
      primaryColor,
    );
  }
}