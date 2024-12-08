import 'dart:async';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Enviroment.initEnviroment();
  final appInfo = await PackageInfo.fromPlatform();
  DataConstant.appVersion = appInfo.version;
  DataConstant.buildNumber = appInfo.buildNumber;
  final themeProvider = ThemeProvider();
  await themeProvider.loadDarkModeFromStorage();

  runApp(
    ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: const App()   
    )
    
    );
}