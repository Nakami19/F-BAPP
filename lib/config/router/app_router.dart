import 'package:f_bapp/config/helpers/fade_page_transition.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/auth/second_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/modules/administration/administration_screen.dart';
import 'package:f_bapp/presentation/screens/modules/ldap/ldap_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/create_order_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/list_devolutions_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/list_mobile_payments.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/list_orders_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/list_profits_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/merchant_actions_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/refund_payments_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/unclaimed_payments_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/onboarding_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/templates_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/verifications_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboardingV1/onboardingv1_screen.dart';
import 'package:f_bapp/presentation/screens/modules/operations/operations_screen.dart';
import 'package:f_bapp/presentation/screens/profile/profile_screen.dart';
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
      
      case listmerchantdevolutionsScreen:
        return FadePageTransition(builder: (_) =>  const ListDevolutionsScreen());
      
      case listmerchantordersScreen:
        return FadePageTransition(builder: (_) => const ListOrdersScreen());
      
      case listmobilepaymentsScreen:
        return FadePageTransition(builder: (_) => const ListMobilePayments());
      
      case unclaimedpaymentsScreen:
        return FadePageTransition(builder: (_) => const UnclaimedPaymentsScreen());
      
      case refundpaymentsScreen:
        return FadePageTransition(builder: (_) => const RefundPaymentsScreen());
      
      case createorderScreen:
        return FadePageTransition(builder: (_) => const CreateOrderScreen());
      
      case listprofitsScreen:
        return FadePageTransition(builder: (_) => const ListProfitsScreen());
      
      case verificationsScreen:
        return FadePageTransition(builder: (_) => const VerificationsScreen());
      
      case templatesScreen:
        return FadePageTransition(builder: (_) => const TemplatesScreen());

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