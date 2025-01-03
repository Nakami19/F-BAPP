import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/app_providers.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/router/app_router.dart';
import 'flavors.dart';


final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        initialRoute: firstLoginScreen,
        onGenerateInitialRoutes:(initialRoute) => [AppRouter.generateRoute(RouteSettings(name: initialRoute))],
        onGenerateRoute: AppRouter.generateRoute,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: FlavorConfig.flavorValues.environmentName,
        theme: AppTheme.themeLight(),
       darkTheme:AppTheme.themeDark(primaryColor),
       themeMode:
            themeProvider.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,

      // Esto permite que no se modifique el tamano de la app, aunque si se modifique el del dispositivo
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: child ?? const SizedBox.shrink(),
              );
        }, 
      ),
    );
  }

}
