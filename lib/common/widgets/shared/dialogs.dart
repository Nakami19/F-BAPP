import 'package:f_bapp/common/assets/theme/app_colors.dart';
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


}
