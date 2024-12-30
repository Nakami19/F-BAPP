import 'package:f_bapp/common/widgets/cards/information_card.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/shared/navigation_provider.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key, this.id});

  final String? id;
  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<ScaffoldState> _userScaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
        drawer: DrawerMenu(),
        key: _userScaffoldKey,
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
            preferredSize: const Size.fromHeight(110),
            child: Screensappbar(
              title: 'Datos del usuario',
              screenKey: _userScaffoldKey,
            )),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
             const SizedBox(
                height: 5,
              ),
              Padding(
                padding:
                   const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InformationCard(
                    title: "Datos del usuario",
                    // subtitle: merchantProvider.idOrder??widget.id??"",
                    texts: buildTextsFromUser(),
                    ),
              ),

            ]),
          ),
        ));
  }

  List<Map<String, dynamic>> buildTextsFromUser() {
    List<Map<String, dynamic>> objects = [];
    final merchantProvider = context.read<MerchantProvider>();
    Map<String, dynamic> userdata= merchantProvider.userData!;

    if (userdata['firstName'] != null) {
      objects.add({
        'label': 'Primer nombre: ',
        'value': userdata["firstName"]
      });
    }

    if (userdata['secondName'] != null) {
      objects.add({
        'label': 'Segundo nombre: ',
        'value': userdata["secondName"]
      });
    }

    if (userdata["lastname"] != null) {
      objects.add({
        'label': 'Primer apellido: ',
        'value': userdata["lastname"]
      });
    }

    if (userdata["surname"] != null) {
      objects.add({
        'label': 'Segundo apellido: ',
        'value': userdata["surname"]
      });
    }

    if (userdata["phoneNumber"] != null) {
      objects.add({
        'label': 'Teléfono: ',
        'value': userdata["phoneNumber"]
      });
    }

    if (userdata["documentId"] != null) {
      objects.add({
        'label': 'Documento de identidad: ',
        'value': userdata["documentId"]
      });
    }

    return objects;
  }
}