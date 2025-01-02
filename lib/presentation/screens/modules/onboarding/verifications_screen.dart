import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/shared/screens_appbar.dart';

class VerificationsScreen extends StatefulWidget {
  const VerificationsScreen({super.key});

  @override
  State<VerificationsScreen> createState() => _VerificationsScreenState();
}

class _VerificationsScreenState extends State<VerificationsScreen> {
  final GlobalKey<ScaffoldState> _verificationsScaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      drawer: DrawerMenu(),
      key: _verificationsScaffoldKey,
       onDrawerChanged: (isOpened) {
          if (!isOpened) {
            Future.delayed(Duration(milliseconds: navProvider.showNavBarDelay),
                () {
              navProvider.updateShowNavBar(true);
            });
          } else {
            navProvider.updateShowNavBar(false);
          }
        },
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: Screensappbar(
              title: 'Verificaciones',
              screenKey: _verificationsScaffoldKey,
              poproute: onboardingScreen,
              onBack: () {
                // merchantProvider.disposeValues();
              },
            )),
    );
  }
}