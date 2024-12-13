import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListMobilePayments extends StatefulWidget {
  const ListMobilePayments({super.key});

  @override
  State<ListMobilePayments> createState() => _ListMobilePaymentsState();
}

class _ListMobilePaymentsState extends State<ListMobilePayments> {
  final GlobalKey<ScaffoldState> _listmobilepaymentScaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _listmobilepaymentScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
            title: 'Listado de pagos móviles',
            screenKey: _listmobilepaymentScaffoldKey,
            poproute: merchantScreen,
          )),

    bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),

    );
  }
}
