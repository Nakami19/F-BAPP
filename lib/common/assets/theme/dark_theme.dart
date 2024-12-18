part of 'app_theme.dart';

ThemeData themeDataDark(Color themeColor, Color primaryColor) {

  final ThemeData base = ThemeData.dark();

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      shape: LinearBorder(),
      backgroundColor: darkColor,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return checkBoxColor;
          }
          return null; // Usa el color activo por defecto para otros estados
        },
      ),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: darkColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColor,
      selectedIconTheme: IconThemeData(color: themeColor),
      unselectedItemColor: unselectedItemColor,
      selectedItemColor: themeColor,
      selectedLabelStyle: TextStyle(
        color: themeColor,
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: themeColor,
    ),

    // Scaffold
    scaffoldBackgroundColor: darkColor,
    dialogTheme: DialogTheme(
      backgroundColor: containerColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
    ),

    // Appbar
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: containerColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      shadowColor: appBarShadowColor,
      iconTheme: IconThemeData(
        color: themeColor,
      ),
      backgroundColor: containerColor,
      // backgroundColor: darkColor,
      scrolledUnderElevation: 0,
      elevation: 0,

      centerTitle: false,
      titleTextStyle: TextStyle(
        color: themeColor,
        fontSize: 16,
      ),
    ),

    // Color fondo dialogos
    dialogBackgroundColor: darkColor,

    // TextFields
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(
        color: inputErrorColor,
      ),
      suffixIconColor: textFieldColor,
      isDense: true,
      filled: true,
      fillColor: containerColor,
      labelStyle: TextStyle(
        fontSize: 18,
        color: primaryColor,
      ),
      hintStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: textFieldColor,
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.2,
          color: textFieldBorderColor,
        ),
      ),
      errorMaxLines: 6,
      enabledBorder: border.copyWith(
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.2,
        ),
      ),
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: themeColor,
          width: 1.2,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(
          color: Colors.red.shade800,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(
          color: Colors.red.shade800,
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: themeColor,
      textColor: themeColor,
      selectedColor: primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
    ),

    // Botones
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        disabledBackgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: themeColor,
        side: BorderSide(
            // color: primaryColor,
            color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
      ),
    ),

    cardTheme: const CardTheme(
      elevation: 2,
      color: containerColor,
      surfaceTintColor: darkColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadiusValue),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: themeColor,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),

    // Textos

    textTheme: _buildTextTheme(
      base.textTheme,
      themeColor,
    ),
    primaryTextTheme: _buildTextTheme(
      base.textTheme,
      themeColor,
    ),
  );
}