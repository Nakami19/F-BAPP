import 'package:f_bapp/config/helpers/fade_page_transition.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/auth/second_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/tab_screen.dart';
import 'package:f_bapp/presentation/screens/terms_condition_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case firstLoginScreen:
        return FadePageTransition(builder: (_) => const FirstLoginScreen());
      
      case secondLoginScreen:
        return FadePageTransition(
          builder: (_) => const SecondLoginScreen(),
        );
      
      case termsConditionsScreen:
        return FadePageTransition(
          builder: (_) => const TermsConditionScreen(),
        );

      case homeScreen:
        return FadePageTransition(builder: (_) => const HomeScreen());
      
      case tabsScreen:
        return FadePageTransition(builder: (_) => const BottomNavBar());
      
      default:
        return FadePageTransition(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no definida para ${settings.name}'),
            ),
          ),
        );
    }
  }
}