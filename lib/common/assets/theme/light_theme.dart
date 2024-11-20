part of 'app_theme.dart';

ThemeData themeDataLight(Color textColor) {
  final ThemeData base = ThemeData.light();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
    ),

    // drawerTheme: DrawerThemeData(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(5),
    //   ),
    // ),

    // bottomSheetTheme: const BottomSheetThemeData(
    //   shape: LinearBorder(),
    // ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: textColor,
    ),

    // Scaffold
    scaffoldBackgroundColor: primaryScaffoldColor,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BorderRadiusValue),
      ),
    ),

    // Appbar
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      scrolledUnderElevation: 0,
      shadowColor: Colors.grey,
      iconTheme: IconThemeData(color: textColor),
      backgroundColor: primaryScaffoldColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
    ),

    // Color fondo dialogos
    dialogBackgroundColor: Colors.white,

    // TextFields
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.grey[50],
      labelStyle: TextStyle(
        fontSize: 18,
        color: textColor,
      ),
      hintStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: Color(0xFFA09F9F),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.2,
          color: Colors.grey,
        ),
      ),
      errorMaxLines: 6,
      enabledBorder: border.copyWith(
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.2,
        ),
      ),
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: textColor,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BorderRadiusValue),
      ),
    ),

    // Botones
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusValue),
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusValue),
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusValue),
        ),
      ),
    ),

    cardTheme: const CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(BorderRadiusValue),
        ),
      ),
      elevation: 7,
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusValue),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),

    // Textos
    textTheme: _buildTextTheme(
      base.textTheme,
      textColor,
    ),
    primaryTextTheme: _buildTextTheme(
      base.textTheme,
      textColor,
    ),
  );
}
