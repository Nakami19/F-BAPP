import 'package:f_bapp/config/helpers/fade_page_transition.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/auth/second_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/modules/administration/administration_screen.dart';
import 'package:f_bapp/presentation/screens/modules/ldap/ldap_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/merchant_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/onboarding_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboardingV1/onboardingv1_screen.dart';
import 'package:f_bapp/presentation/screens/modules/operations/operations_screen.dart';
import 'package:f_bapp/presentation/screens/profile/profile_screen.dart';
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
      
      case profileScreen:
        return FadePageTransition(builder: (_) => const ProfileScreen());
      
      case tabsScreen:
        return FadePageTransition(builder: (_) => const BottomNavBar());
      
      case operationsScreen:
        return FadePageTransition(builder: (_) => const OperationsScreen());
      
      case merchantScreen:
        return FadePageTransition(builder: (_) => const MerchantScreen());
      
      case onboardingScreen:
        return FadePageTransition(builder: (_) => const OnboardingScreen());
      
      case onboardingV1Screen:
        return FadePageTransition(builder: (_) => const Onboardingv1Screen());
      
      case administrationScreen:
        return FadePageTransition(builder: (_) => const AdministrationScreen());
      
      case ldapScreen:
        return FadePageTransition(builder: (_) => const LdapScreen());

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