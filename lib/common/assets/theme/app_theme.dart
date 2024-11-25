import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

part 'fonts.dart';
part 'light_theme.dart';
part 'dark_theme.dart';

const Color primaryColor = Color(0xFF14C6A4);
const Color secondaryColor = Color(0xFF6A9CF3);
const Color primaryScaffoldColor = Color(0xFFFFFFFF);
const Color lightColor = Color(0xFFf1f4f8);
const Color errorColor = Color(0xFFEA3A3D);

// * DARK MODE
const darkColor = Color(0xFF333333); //negro oscuro SOLO FONDO
const containerColor = Color(0xFF3f3f3f); //negro claro
const darkSecondaryColor = Color(0xFF2e2926);

// Border radius
const double BorderRadiusValue = 30;

class AppTheme {
  final bool isDarkModeEnabled;

  static Color secColorScaffold = const Color(0xFFFFFFFF);
  static Color dialogsBarrierColor = const Color(0xFF24264D).withOpacity(0.75);
  static const lightThemeTextColor = Color.fromARGB(255, 35, 43, 58);

  // Variable color de placeholders gris
  static const hintTextColor = Color(0xDDc9c7c7);

  late Color textColor;

  AppTheme({
    this.isDarkModeEnabled = false,
  });
  ThemeData theme(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    if (themeProvider.isDarkModeEnabled) {
      textColor = Colors.white;
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