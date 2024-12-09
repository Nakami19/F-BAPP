import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  final GlobalKey<ScaffoldState> _administrationScaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _administrationScaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Screensappbar(title: 'Administración', screenKey: _administrationScaffoldKey, poproute: homeScreen)
      ),

      bottomNavigationBar:Customnavbar(
        selectedIndex: 2, 
        onDestinationSelected:(index) {
          navProvider.updateIndex(index);
        } ),

    );
  }
}