import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefundPaymentsScreen extends StatefulWidget {
  const RefundPaymentsScreen({super.key});

  @override
  State<RefundPaymentsScreen> createState() => _RefundPaymentsScreenState();
}

class _RefundPaymentsScreenState extends State<RefundPaymentsScreen> {
    final GlobalKey<ScaffoldState> _refundpaymentsScaffoldKey =
      GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _refundpaymentsScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Envío de pago móvil (vuelto)', screenKey: _refundpaymentsScaffoldKey, poproute: merchantScreen,)),
      bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),
    );
  }
}