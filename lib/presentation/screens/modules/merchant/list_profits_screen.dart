import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProfitsScreen extends StatefulWidget {
  const ListProfitsScreen({super.key});

  @override
  State<ListProfitsScreen> createState() => _ListProfitsScreenState();
}

class _ListProfitsScreenState extends State<ListProfitsScreen> {
    final GlobalKey<ScaffoldState> _listprofitsScaffoldKey =
      GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _listprofitsScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Listado de aliados', screenKey: _listprofitsScaffoldKey, poproute: merchantScreen,)),
      bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),
    );
  }
}