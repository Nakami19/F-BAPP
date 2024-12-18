import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;
  final storage = SecureStorageService();

  bool get isDarkModeEnabled => _isDarkModeEnabled;

//Carga el estado del tema desde el almacenamiento seguro.
  ThemeProvider() {
    loadDarkModeFromStorage();
  }

// Método para cargar el estado del tema desde el almacenamiento seguro.
   Future<void> loadDarkModeFromStorage() async {

    //Verifica si hay datos para el modo oscuro guardados, de no haber se establece un valor default
    _isDarkModeEnabled = await storage.getValue('darkMode') ?? false;

    // Actualiza el estilo del sistema según el tema actual
    _updateSystemChromeStyle();
    notifyListeners();
  }

  void toggleDarkMode() {

    //Cambia el valor de la variable
    _isDarkModeEnabled = !_isDarkModeEnabled;

    // Actualiza el estilo del sistema según el tema actual
    _updateSystemChromeStyle();
    notifyListeners();
  }

  //Guarda el estado actual del tema
  void _saveDarkModeToStorage() async {
    storage.setKeyValue('darkMode', _isDarkModeEnabled);
  }

  // Actualiza el estilo del sistema según el tema actual
   void _updateSystemChromeStyle() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: _isDarkModeEnabled
          ? Colors.black
          : Colors.white, // Fondo de la barra de navegación
      systemNavigationBarIconBrightness: _isDarkModeEnabled
          ? Brightness.light
          : Brightness.dark, // Color del texto de la barra de navegación
    ));
  }
}