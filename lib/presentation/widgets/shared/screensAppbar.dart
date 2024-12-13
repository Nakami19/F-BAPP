import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Screensappbar extends StatefulWidget {
  const Screensappbar(
      {required this.title,
      required this.screenKey,
      required this.poproute,
      super.key});

  final String title;
  final String poproute;
  final GlobalKey<ScaffoldState> screenKey;

  @override
  State<Screensappbar> createState() => _ScreensappbarState();
}

class _ScreensappbarState extends State<Screensappbar> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading:
          false, // Para personalizar completamente la flecha.
      flexibleSpace: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            '${DataConstant.images}/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 110,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //parte izquieda
                  SizedBox(
                    width:MediaQuery.of(context).size.width/2,
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: 'Atrás',
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              widget.poproute, // Ruta destino
                              (route) => false, // Esto elimina todas las rutas previas
                            );
                          },
                        ),
                        Flexible(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.visible, // Permitir el salto de línea
                            softWrap: true, // Habilitar el ajuste de línea
                          ),
                        ),
                      ],
                    ),
                  ),
                  //parte derecha
                  Row(
                    children: [
                      SvgPicture.asset(
                        '${DataConstant.images_chinchin}/chinchin-logo-business-base.svg',
                        height: 27,
                        fit: BoxFit.contain,
                      ),
                      IconButton(
                        tooltip: 'Menú',
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          if (!userProvider.isLoading) {
                            widget.screenKey.currentState!.openDrawer();
                          }
                        },
                      ),
                    ],
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
