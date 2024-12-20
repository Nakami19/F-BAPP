import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Screensappbar extends StatefulWidget {
  const Screensappbar(
      {required this.title,
      required this.screenKey,
      this.poproute,
      this.onBack,
      super.key});

  final String title;
  final String? poproute;
  final GlobalKey<ScaffoldState> screenKey;
  final VoidCallback? onBack;

  @override
  State<Screensappbar> createState() => _ScreensappbarState();
}

class _ScreensappbarState extends State<Screensappbar> {
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
            fit: BoxFit.cover,
            width: double.infinity,
            height: 110,
          ),

          //Contenido del appbar
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
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      children: [
                        //Icono flecha
                        IconButton(
                          tooltip: 'Atrás',
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            if (widget.onBack != null) {
                              widget.onBack!();
                            }
                            if (widget.poproute != null) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                widget.poproute!, // Ruta destino
                                (route) =>
                                    false, // Elimina todas las rutas previas
                              );
                            } else {
                              Navigator.pop(
                                  context); // Regresa a la ruta anterior
                            }
                          },
                        ),

                        //Nombre de vista actual
                        Flexible(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow
                                .visible, // Permitir el salto de línea
                            softWrap: true, // Habilitar el ajuste de línea
                          ),
                        ),
                      ],
                    ),
                  ),

                  //parte derecha
                  Row(
                    children: [
                      //Logo de business
                      SvgPicture.asset(
                        '${DataConstant.imagesChinchin}/chinchin-logo-business-base.svg',
                        height: 27,
                        fit: BoxFit.contain,
                      ),

                      //Icono menu
                      IconButton(
                        tooltip: 'Menú',
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          if (!userProvider.isLoading) {
                            //Abre el side menu
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
