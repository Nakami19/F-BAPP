import 'dart:async';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/presentation/providers/shared/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Enviroment.initEnviroment();
  final themeProvider = ThemeProvider();
  await themeProvider.loadDarkModeFromStorage();

  runApp(
    ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: const App()   
    )
    
    );
}