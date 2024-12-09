import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Onboardingv1Screen extends StatefulWidget {
  const Onboardingv1Screen({super.key});

  @override
  State<Onboardingv1Screen> createState() => _Onboardingv1ScreenState();
}

class _Onboardingv1ScreenState extends State<Onboardingv1Screen> {
  final GlobalKey<ScaffoldState> _onboardingV1ScaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _onboardingV1ScaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Screensappbar(title: 'Onboarding v1', screenKey: _onboardingV1ScaffoldKey)
      ),

      bottomNavigationBar:Customnavbar(
        selectedIndex: 2, 
        onDestinationSelected:(index) {
          navProvider.updateIndex(index);
        } ),

    );
  }
}