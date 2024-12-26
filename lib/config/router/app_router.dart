import 'package:f_bapp/config/helpers/fade_page_transition.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/auth/second_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/main_screen.dart';
import 'package:f_bapp/presentation/screens/modules/administration/administration_screen.dart';
import 'package:f_bapp/presentation/screens/modules/ldap/ldap_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/create_order_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/devolutions/devolution_detail_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/devolutions/list_devolutions_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/mobile_payments/list_mobile_payments.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/list_profits_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/merchant_actions_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/mobile_payments/payment_detail_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/list_orders_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/order_detail_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/payment_history_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/user_details_screen.dart';
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
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 0, child: HomeScreen()));

      case profileScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 1, child: ProfileScreen()));

      case operationsScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: OperationsScreen()));

      case merchantScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: MerchantScreen()));

      case onboardingScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: OnboardingScreen()));

      case onboardingV1Screen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: Onboardingv1Screen()));

      case administrationScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: AdministrationScreen()));

      case ldapScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: LdapScreen()));

      case listmerchantdevolutionsScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: ListDevolutionsScreen()));

      case refunddetailScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: DevolutionDetailScreen()));

      case listmerchantordersScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: ListOrdersScreen()));

      case orderdetailScreen:
        final String orderId = settings.arguments as String;
        return FadePageTransition(
          builder: (_) => MainScreen(
            selectedIndex: 2,
            child: OrderDetailScreen(orderId: orderId),
          ),
        );
      
      case paymentHistory:
      final String id = settings.arguments as String;
        return FadePageTransition(
          builder: (_) => MainScreen(
            selectedIndex: 2,
            child: PaymentHistoryScreen(id: id,),
          ),
        );

      case paymentDetail:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: PaymentDetailScreen()));

      case listmobilepaymentsScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: ListMobilePayments()));

      case unclaimedpaymentsScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: UnclaimedPaymentsScreen()));

      case refundpaymentsScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: RefundPaymentsScreen()));

      case createorderScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: CreateOrderScreen()));

      case listprofitsScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: ListProfitsScreen()));

      case verificationsScreen:
        return FadePageTransition(
            builder: (_) => const MainScreen(
                selectedIndex: 2, child: VerificationsScreen()));

      case templatesScreen:
        return FadePageTransition(
            builder: (_) =>
                const MainScreen(selectedIndex: 2, child: TemplatesScreen()));
      
      case userdetailScreen:
      final String id = settings.arguments as String;
        return FadePageTransition(
            builder: (_) =>
                 MainScreen(selectedIndex: 2, child: UserDetailsScreen(id: id,)));

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
