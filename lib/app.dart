import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/router/app_router.dart';
import 'flavors.dart';

class App extends StatelessWidget {

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: firstLoginScreen,
      onGenerateInitialRoutes:(initialRoute) => [AppRouter.generateRoute(RouteSettings(name: initialRoute))],
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      title: FlavorConfig.flavorValues.environmentName,
      theme: AppTheme.themeLight(),
     darkTheme:AppTheme.themeDark(primaryColor),
   
    );
  }

}
