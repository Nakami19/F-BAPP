import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/custom_navbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnclaimedPaymentsScreen extends StatefulWidget {
  const UnclaimedPaymentsScreen({super.key});

  @override
  State<UnclaimedPaymentsScreen> createState() => _UnclaimedPaymentsScreenState();
}

class _UnclaimedPaymentsScreenState extends State<UnclaimedPaymentsScreen> {
    final GlobalKey<ScaffoldState> _unclaimedpaymentsScaffoldKey =
      GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _unclaimedpaymentsScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Pagos no reclamados', screenKey: _unclaimedpaymentsScaffoldKey, poproute: merchantScreen,)),
      bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),
    );
  }
}