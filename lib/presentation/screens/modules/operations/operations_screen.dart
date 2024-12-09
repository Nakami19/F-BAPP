import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  final GlobalKey<ScaffoldState> _operationsScaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _operationsScaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Screensappbar(title: 'Operaciones', screenKey: _operationsScaffoldKey, poproute: homeScreen)
      ),

      bottomNavigationBar:Customnavbar(
        selectedIndex: 2, 
        onDestinationSelected:(index) {
          navProvider.updateIndex(index);
        } ),

    );
  }
}