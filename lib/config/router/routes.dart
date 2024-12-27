import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/auth/second_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/main_screen.dart';
import 'package:f_bapp/presentation/screens/modules/administration/administration_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/create_order_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/devolutions/devolution_detail_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/devolutions/list_devolutions_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/list_profits_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/merchant_actions_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/mobile_payments/list_mobile_payments.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/mobile_payments/payment_detail_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/list_orders_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/order_detail_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/payment_history_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/orders/user_details_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/mobile_payments/refund_payments_screen.dart';
import 'package:f_bapp/presentation/screens/modules/merchant/unclaimed_payments_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/onboarding_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/templates_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboarding/verifications_screen.dart';
import 'package:f_bapp/presentation/screens/modules/onboardingV1/onboardingv1_screen.dart';
import 'package:f_bapp/presentation/screens/modules/operations/operations_screen.dart';
import 'package:f_bapp/presentation/screens/profile/profile_screen.dart';
import 'package:f_bapp/presentation/screens/terms_condition_screen.dart';
import 'package:flutter/material.dart';

const String firstLoginScreen = '/firstLogin';
const String secondLoginScreen = '/secondLogin';
const String homeScreen = '/home';
const String termsConditionsScreen = '/termsConditionsScreen';
// const String tabsScreen = '/tabsScreen';
const String userdetailScreen = '/Datos usuario';

//Dashboard
const String profileScreen = '/profileScrenn';
const String operationsScreen = '/OperacionesScreen';
const String merchantScreen = '/MerchantScreen';
const String onboardingScreen = '/OnboardingScreen';
const String onboardingV1Screen = '/Onboarding v1Screen';
const String administrationScreen = '/AdministraciónScreen';
const String ldapScreen = '/LdapScreen';

//Merchant
const String listmerchantdevolutionsScreen = '/Listado de devolucionesScreen';
const String listmerchantordersScreen = '/Listado de órdenesScreen';
const String listmobilepaymentsScreen = '/Listado de pagos móvilesScreen';
const String unclaimedpaymentsScreen = '/Pagos no reclamadosScreen';
const String refundpaymentsScreen = '/Envío de pago móvil (vuelto)Screen';
const String createorderScreen = '/Crear orden pasarelaScreen';
const String listprofitsScreen = '/Listado de aliadosScreen';
const String orderdetailScreen = '/Detalle de orden';
const String paymentHistory = '/Historial de pagos';
const String paymentDetail = '/Detalle de pago';
const String refunddetailScreen = '/Detalle de devolucion';

//Onboarding
const String verificationsScreen = '/VerificacionesScreen';
const String templatesScreen = '/PlantillasScreen';
const String membreshipsScreen = '/MembresíaScreen';
const String achievementsScreen = '/LogrosScreen';

//Onboarding V1
// const String verificationsV1 = '/Verification'
const String templatesV1Screen = '/V1 PlantillasScreen';

//Administration
const String userlistScreen = '/Listado de usuarios registradosScreen';

//Operations
const String listtransactionsScreen = '/Listado de transaccionesScreen';
const String paymentservicesScreen = '/Pago de serviciosScreen';
const String paymentbankScreen = '/Realizar transferenciaScreen';
const String paymentmobileScreen = '/Realizar pago móvilScreen';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    firstLoginScreen: (_) => const FirstLoginScreen(),
    secondLoginScreen: (_) => const SecondLoginScreen(),
    termsConditionsScreen: (_) => const TermsConditionScreen(),
    profileScreen: (_) =>
        const MainScreen(selectedIndex: 1, child: ProfileScreen()),
    homeScreen: (_) => const MainScreen(selectedIndex: 0, child: HomeScreen()),

    //Merchant
    merchantScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: MerchantScreen()),
    listmerchantdevolutionsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: ListDevolutionsScreen()),
    refunddetailScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: DevolutionDetailScreen()),
    listmerchantordersScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: ListOrdersScreen()),
    orderdetailScreen: (_) => const MainScreen(
          selectedIndex: 2,
          child: OrderDetailScreen(),
        ),
    paymentHistory: (_) => const MainScreen(
          selectedIndex: 2,
          child: PaymentHistoryScreen(),
        ),
    paymentDetail: (_) =>
        const MainScreen(selectedIndex: 2, child: PaymentDetailScreen()),
    listmobilepaymentsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: ListMobilePayments()),
    unclaimedpaymentsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: UnclaimedPaymentsScreen()),
    refundpaymentsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: RefundPaymentsScreen()),
    createorderScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: CreateOrderScreen()),
    listprofitsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: ListProfitsScreen()),
    userdetailScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: UserDetailsScreen()),


    //Onboarding
    onboardingScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: OnboardingScreen()),
    verificationsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: VerificationsScreen()),
    templatesScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: TemplatesScreen()),

    //Operations
    operationsScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: OperationsScreen()),

    //OnboardingV1
    onboardingV1Screen: (_) =>
        const MainScreen(selectedIndex: 2, child: Onboardingv1Screen()),

    //Administration
    administrationScreen: (_) =>
        const MainScreen(selectedIndex: 2, child: AdministrationScreen()),
  };
}
