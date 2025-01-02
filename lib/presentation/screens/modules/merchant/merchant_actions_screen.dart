import 'package:f_bapp/common/widgets/cards/large_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  final GlobalKey<ScaffoldState> _merchantScaffoldKey =
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
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      drawer: DrawerMenu(),
      key: _merchantScaffoldKey,
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
          preferredSize: Size.fromHeight(80 + MediaQuery.of(context).padding.top),
          child: Screensappbar(
            title: 'Merchant',
            screenKey: _merchantScaffoldKey,
            poproute: homeScreen,
          )),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          height: MediaQuery.of(context).size.height,
          //Se construyen las tarjetas
          child: ListView.builder(
              itemCount: showactions.length,
              itemBuilder: (context, index) {
                final action = showactions[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: LargeCard(
                    image:
                        '${DataConstant.imagesModules}/${DataConstant.modulePathMerchant}/chinchin-${action.key}_merchant-on.svg',
                    placeholder:
                        '${DataConstant.imagesModules}/${DataConstant.modulePathMerchant}/chinchin-list_merchant_devolutions_merchant-on.svg',
                    title: action.actionName,
                    height: 85,
                    textStyle: textStyle.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/${action.actionName}Screen');
                    },
                  ),
                );
              }),
        ),
      ),
      // bottomNavigationBar: Customnavbar(
      //     selectedIndex: 2,
      //     onDestinationSelected: (index) {
      //       navProvider.updateIndex(index);
      //     }),
    );
  }
}
