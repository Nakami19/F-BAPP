import 'package:f_bapp/config/helpers/fade_page_transition.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:flutter/material.dart';

class AppRouter {

   static Route<dynamic> generateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = AppRoutes.routes[settings.name];
    if (builder != null) {
      return FadePageTransition(builder: builder);
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Ruta no definida para ${settings.name}'),
        ),
      ),
    );
   }

  // static Route<dynamic> generateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case firstLoginScreen:
  //       return FadePageTransition(builder: (_) => const FirstLoginScreen());

  //     case secondLoginScreen:
  //       return FadePageTransition(
  //         builder: (_) => const SecondLoginScreen(),
  //       );

  //     case termsConditionsScreen:
  //       return FadePageTransition(
  //         builder: (_) => const TermsConditionScreen(),
  //       );

  //     case homeScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 0, child: HomeScreen()));

  //     case profileScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 1, child: ProfileScreen()));

  //     case operationsScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: OperationsScreen()));

  //     case merchantScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: MerchantScreen()));

  //     case onboardingScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: OnboardingScreen()));

  //     case onboardingV1Screen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: Onboardingv1Screen()));

  //     case administrationScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: AdministrationScreen()));

  //     case ldapScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: LdapScreen()));

  //     case listmerchantdevolutionsScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: ListDevolutionsScreen()));

  //     case refunddetailScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: DevolutionDetailScreen()));

  //     case listmerchantordersScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: ListOrdersScreen()));

  //     case orderdetailScreen:
  //       return FadePageTransition(
  //         builder: (_) => MainScreen(
  //           selectedIndex: 2,
  //           child: OrderDetailScreen(),
  //         ),
  //       );
      
  //     case paymentHistory:
  //       return FadePageTransition(
  //         builder: (_) => MainScreen(
  //           selectedIndex: 2,
  //           child: PaymentHistoryScreen(),
  //         ),
  //       );

  //     case paymentDetail:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: PaymentDetailScreen()));

  //     case listmobilepaymentsScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: ListMobilePayments()));

  //     case unclaimedpaymentsScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: UnclaimedPaymentsScreen()));

  //     case refundpaymentsScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: RefundPaymentsScreen()));

  //     case createorderScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: CreateOrderScreen()));

  //     case listprofitsScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: ListProfitsScreen()));

  //     case verificationsScreen:
  //       return FadePageTransition(
  //           builder: (_) => const MainScreen(
  //               selectedIndex: 2, child: VerificationsScreen()));

  //     case templatesScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //               const MainScreen(selectedIndex: 2, child: TemplatesScreen()));
      
  //     case userdetailScreen:
  //       return FadePageTransition(
  //           builder: (_) =>
  //                MainScreen(selectedIndex: 2, child: UserDetailsScreen()));

  //     default:
  //       return FadePageTransition(
  //         builder: (_) => Scaffold(
  //           body: Center(
  //             child: Text('Ruta no definida para ${settings.name}'),
  //           ),
  //         ),
  //       );
  //   }
  // }
}
