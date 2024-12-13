import 'package:f_bapp/common/widgets/cards/large_card.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  final GlobalKey<ScaffoldState> _merchantScaffoldKey =
      GlobalKey<ScaffoldState>();
  
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
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      drawer: DrawerMenu(),
      key: _merchantScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Merchant', screenKey: _merchantScaffoldKey, poproute: homeScreen,)),
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
                        image: '${DataConstant.images_modules}/${action.key}_merchant-on.svg',
                        placeholder: '${DataConstant.images_modules}/list_merchant_devolutions_merchant-on.svg',
                        title: action.actionName,
                        height: 85,
                        textStyle: textStyle.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/${action.actionName}Screen');
                        } ,
                      ),
                    ),
                  ),
                );
              }),
        ),
        // child: SingleChildScrollView(
        // child: Column(
        //         children: [
        //           SizedBox(height: 20), // Espacio antes del primer elemento
        //           Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 25),
        // child: LargeCard(
        //   image: '${DataConstant.images_modules}/icono_listado_devoluciones.svg',
        //   title: 'Hola',
        //   onTap: ()=>{print(userProvider.privileges)},
        //   height: 90,
        //   textStyle: textStyle.bodyMedium!.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //           ),
        //           SizedBox(height: 33),
        //           Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 25),
        // child: LargeCard(
        //   image: '${DataConstant.images_modules}/icono_listado_devoluciones.svg',
        //   title: 'Listado de ordenes',
        //   height: 90,
        //   textStyle: textStyle.bodyMedium!.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //           ),
        //           SizedBox(height: 33),
        //           Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 25),
        // child: LargeCard(
        //   image: '${DataConstant.images_modules}/icono_listado_devoluciones.svg',
        //   title: 'Listado de pagos moviles',
        //   height: 90,
        //   textStyle: textStyle.bodyMedium!.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //           ),
        //           SizedBox(height: 33),
        //           Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 25),
        // child: LargeCard(
        //   image: '${DataConstant.images_modules}/icono_listado_devoluciones.svg',
        //   title: 'Envio de pago movil (vuelto)',
        //   height: 90,
        //   textStyle: textStyle.bodyMedium!.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //           ),
        //           SizedBox(height: 33),
        //           Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 25),
        // child: LargeCard(
        //   image: '${DataConstant.images_modules}/icono_listado_devoluciones.svg',
        //   title: 'Crear orden de pasarela',
        //   height: 90,
        //   textStyle: textStyle.bodyMedium!.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        //           ),
        //           SizedBox(height: 20), // Espacio después del último elemento
        //         ],
        // ),
      ),
      bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),
    );
  }
}
