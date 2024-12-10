import 'package:f_bapp/common/widgets/cards/large_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LdapScreen extends StatefulWidget {
  const LdapScreen({super.key});

  @override
  State<LdapScreen> createState() => _LdapScreenState();
}

class _LdapScreenState extends State<LdapScreen> {
  final GlobalKey<ScaffoldState> _ldapScaffoldKey = GlobalKey<ScaffoldState>();

  var showactions=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //se filtran las acciones que deben mostrarse
    final userProvider = context.read<UserProvider>();
    showactions = userProvider.actions.where((action) => action.showInMenu == true).toList();
    
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      drawer: DrawerMenu(),
      key: _ldapScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Ldap',
              screenKey: _ldapScaffoldKey,
              poproute: homeScreen)),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              itemCount: showactions.length,
              itemBuilder: (context, index) {
                final action = showactions[index];
                return GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: LargeCard(
                        image:
                            '${DataConstant.images_modules}/${action.key}_ldap-on.svg',
                        placeholder:
                            '${DataConstant.images_modules}/cmer-create_order_merchant-on.svg',
                        title: action.actionName,
                        height: 85,
                        textStyle: textStyle.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
      bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),
    );
  }
}
