import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Dialogs {
  static TextStyle fontStyle = const TextStyle(fontSize: 18);

  //Dialogo custom
  static customDialog(BuildContext context,
      {required String title,
      Widget? content,
      bool? showButtons = true,
      bool? showOnlyConfirmButton = false,
      String? confirmButtonText = 'CONFIRMAR',
      String? cancelButtonText = 'CANCELAR',
      required VoidCallback actionSuccess,
      VoidCallback? closeAction}) {
    final themeProvider = context.watch<ThemeProvider>();
    final textStyle = Theme.of(context).textTheme.labelMedium;

    return AlertDialog(
      backgroundColor:
          themeProvider.isDarkModeEnabled ? darkColor : primaryScaffoldColor,
      title: Text(
        title,
        style: fontStyle,
        textAlign: TextAlign.center,
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.center,

      //El contenido cambia si se muestran uno o dos botones
      actions: showButtons != null && showButtons
          ? showOnlyConfirmButton != null && showOnlyConfirmButton
              ? <Widget>[
                //Caso donde se muestra un boton
                  CustomButton(
                      title: confirmButtonText ?? 'ACEPTAR',
                      isPrimaryColor: true,
                      isOutline: false,
                      onTap: actionSuccess,
                      height: 50,
                      provider: GeneralProvider())
                ]
              : <Widget>[

                //Caso donde se muestran dos botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),

                          child: CustomButton(
                              title: cancelButtonText ?? 'CANCELAR',
                              isPrimaryColor: false,
                              isOutline: false,
                              isText: true,
                              width: 90,
                              height: 50,
                              paddingH: 0,
                              styleText: textStyle!.copyWith(
                                color: const Color.fromRGBO(252, 198, 20, 100),
                                fontSize: 10,
                              ),
                              styleTextButton: TextButton.styleFrom(
                                side: const BorderSide(
                                  color: Color.fromRGBO(252, 198, 20,
                                      100), 
                                  width: 2,
                                ),
                              ),
                              onTap: closeAction ??
                                  () => Navigator.pop(context, false),
                              provider: GeneralProvider()),
                        ),
                      ),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),

                          child: CustomButton(
                              title: confirmButtonText ?? 'CONFIRMAR',
                              isPrimaryColor: true,
                              isOutline: false,
                              width: 90,
                              paddingH: 0,
                              height: 50,
                              onTap: actionSuccess,
                              styleText: textStyle!.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              provider: GeneralProvider()),
                        ),
                      ),
                    ],
                  )

                ]
          : null,
    );
  }

  /// Dialogo que se muestra si no hay conexión a internet agregada
  static connectivityDialog(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AlertDialog(
      backgroundColor:
          themeProvider.isDarkModeEnabled ? darkColor : primaryScaffoldColor,
      title: const Text(
        'No hay conexión a internet',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content:const Text('Intenta conectarte a una red wifi o móvil'),
    );
  }


  //Mostrar el estado de cargando con un circulo y un indicador "Cargando" o texto personalizado
  static spinKitLoader(BuildContext context,
      {bool isDismissible = false, String? loadingText}) {
    return WillPopScope(
      onWillPop: () async => isDismissible,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SpinKitFadingCircle(
                color: Color(0xFF6A9CF3),
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                loadingText ?? 'Cargando...',
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Menu desplegable
  /// Función para mostrar menu desplegable
  /// - List<String> menuOptios (lista de widgets a mostrar)
  /// - String headerTitle: titulo del menú
  /// - String routeScreen: ruta
  /// - widget? contentBody: widget a mostrar
  static showMenuBottomSheet(BuildContext context,
      {List? menuOptios,
      String? headerTitle,
      Color? color,
      String? routeScreen,
      IconData? iconTitle,
      bool allowClose = true,
      required Widget contentBody}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final textStyle = Theme.of(context).textTheme;

    showModalBottomSheet<void>(
      isDismissible: allowClose, //dice si es posible clickear afuera del menu
      backgroundColor:
          themeProvider.isDarkModeEnabled ? darkColor : primaryScaffoldColor,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(borderRadiusValue)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) {
        //* Wrap del contenido (header y body del shoMenubottomSheet)
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(children: [
              Container(

                  decoration: const BoxDecoration(

                    //* bordes top radius
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadiusValue),
                      topRight: Radius.circular(borderRadiusValue),
                    ),
                  ),

                  //* Aqui meto el header y el body
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // min

                    children: [
                      //* Row para titulo de menu desplegable
                      Row(
                          mainAxisSize: MainAxisSize.min, //max
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //* icono y titulo de la parte superior
                            Container(

                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(0), // puede ser 0
                              decoration: BoxDecoration(
                                color: color ?? primaryColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(borderRadiusValue),
                                  topRight: Radius.circular(borderRadiusValue),
                                ),
                              ),

                              child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max, //min
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [

                                        //* icono
                                        GestureDetector(
                                          child: const Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        
                                        //* titulo, se muestra si se asigna
                                        if (headerTitle != null)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Icono del title
                                              if (iconTitle != null) ...[
                                                Icon(
                                                  iconTitle,
                                                  color: Colors.white,
                                                  weight: 1,
                                                ),
                                                const SizedBox(width: 7),
                                              ],

                                              // Titulo
                                              Text(
                                                headerTitle,
                                                style: textStyle.titleMedium!
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    )),
                              ),
                            ),
                          ]),

                      //* contenido de widgets
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 0),
                        child: contentBody,
                      )
                    ],
                  )),
            ]),
          ),
        );
      },
    );
  }


}
