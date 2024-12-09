import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<ScaffoldState> _onboardingScaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _onboardingScaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: Screensappbar(title: 'Onboarding', screenKey: _onboardingScaffoldKey, poproute: homeScreen)
      ),

      bottomNavigationBar:Customnavbar(
        selectedIndex: 2, 
        onDestinationSelected:(index) {
          navProvider.updateIndex(index);
        } ),

    );
  }
}