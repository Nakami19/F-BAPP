import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DashboardAppbar extends StatefulWidget {
  const DashboardAppbar ({super.key, required this.screenKey});

  final GlobalKey<ScaffoldState> screenKey;

  @override
  State<DashboardAppbar> createState() => _DashboardAppbarState();
}

class _DashboardAppbarState extends State<DashboardAppbar> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            '${DataConstant.imagesChinchin}/chinchin_business_background.png',
          ),

          //Ubicacion del contenido 
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Separación lateral
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //Logo de business
                  SvgPicture.asset(
                    '${DataConstant.imagesChinchin}/chinchin-logo-business-base.svg',
                    height: 40,
                    fit: BoxFit.contain,
                  ),

                  //Icono para el menu
                  IconButton(
                    tooltip: 'Menú',
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      if (!userProvider.isLoading) {
                        //se abre el side menu
                        widget.screenKey.currentState!.openDrawer();
                      }
                    },
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
