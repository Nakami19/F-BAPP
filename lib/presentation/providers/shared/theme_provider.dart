import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkModeEnabled = false;
  final storage = SecureStorageService();

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  ThemeProvider() {
    loadDarkModeFromStorage();
  }

   Future<void> loadDarkModeFromStorage() async {
    _isDarkModeEnabled = await storage.getValue('darkMode') ?? false;
    _updateSystemChromeStyle();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    _updateSystemChromeStyle();
    notifyListeners();
  }


  void _saveDarkModeToStorage() async {
    storage.setKeyValue('darkMode', _isDarkModeEnabled);
  }

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