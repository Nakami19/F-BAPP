part of 'app_theme.dart';

TextTheme _buildTextTheme(TextTheme base, Color textColor) {
  return base.copyWith(
    titleLarge: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    titleMedium: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 18,
      ),
    ),
    titleSmall: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyMedium: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
    ),
    bodyLarge: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 14,
      ),
    ),
    labelLarge: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodySmall: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 12,
      ),
    ),
    headlineMedium: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 34,
      ),
    ),
    displaySmall: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 48,
      ),
    ),
    displayMedium: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 60,
      ),
    ),
    displayLarge: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 96,
      ),
    ),
    headlineSmall: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 24,
      ),
    ),
    labelSmall: GoogleFonts.lato(
      textStyle: TextStyle(
        color: textColor,
        fontSize: 10,
      ),
    ),
  );
}