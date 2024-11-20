import 'package:f_bapp/config/helpers/fade_page_transition.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/auth/login/first_login_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case firstLoginScreen:
        return FadePageTransition(builder: (_) => FirstLoginScreen());
      
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