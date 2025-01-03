import 'package:f_bapp/common/widgets/cards/large_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/custom_navbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
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

  var showactions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //se filtran las acciones que deben mostrarse
    final userProvider = context.read<UserProvider>();
    showactions = userProvider.privilegeActions
        .where((action) => action.showInMenu == true)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      drawer: DrawerMenu(),
      key: _onboardingScaffoldKey,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          Future.delayed( Duration(milliseconds: navProvider.showNavBarDelay), () {
            navProvider.updateShowNavBar(true);
          });
        } else {
          navProvider.updateShowNavBar(false);
        }
      },
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Onboarding',
              screenKey: _onboardingScaffoldKey,
              poproute: homeScreen)),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              itemCount: showactions.length,
              itemBuilder: (context, index) {
                final action = showactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 10),
                  child: LargeCard(
                    image:
                        '${DataConstant.imagesModules}/${DataConstant.modulePathOnboarding}/chinchin-${action.key}_onboarding-on.svg',
                    placeholder:
                        '${DataConstant.imagesModules}/${DataConstant.modulePathOnboarding}/chinchin-details_onboarding_membership_v2_onboarding-on.svg',
                    title: action.actionName,
                    height: 85,
                    // imageHeight: 100,
                    textStyle: textStyle.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    onTap:() {
                      Navigator.pushNamed(
                          context, '/${action.actionName}Screen');
                    } ,
                  ),
                );
              }),
        ),
      ),
      // bottomNavigationBar:Customnavbar(
      //   selectedIndex: 2,
      //   onDestinationSelected:(index) {
      //     navProvider.updateIndex(index);
      //   } ),
    );
  }
}
