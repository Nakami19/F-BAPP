import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/providers/theme_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/app_providers.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Dialogs {
  static TextStyle fontStyle = const TextStyle(fontSize: 18);

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
      actions: showButtons != null && showButtons
          ? showOnlyConfirmButton != null && showOnlyConfirmButton
              ? <Widget>[
                  CustomButton(
                      title: confirmButtonText ?? 'ACEPTAR',
                      isPrimaryColor: true,
                      isOutline: false,
                      onTap: actionSuccess,
                      height: 50,
                      provider: GeneralProvider())
                  // CustomStaticButton(
                  //   title: confirmButtonText ?? 'ACEPTAR',
                  //   isPrimaryColor: true,
                  //   isOutline: false,
                  //   fontSize: 14,
                  //   onTap: actionSuccess,
                  //   paddingHorizontal: 0,
                  // )
                ]
              : <Widget>[
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
                                color: Color.fromRGBO(252, 198, 20, 100),
                                fontSize: 12,
                              ),
                              styleTextButton: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Color.fromRGBO(252, 198, 20,
                                      100), // Cambia a tu color deseado
                                  width: 2, // Grosor del borde
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
                                fontSize: 12,
                              ),
                              provider: GeneralProvider()),
                        ),
                      ),
                    ],
                  )

                  // TextButton(
                  //   style: FilledButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(buttonBorderRadiusValue),
                  //     ),
                  //   ),
                  //   onPressed:
                  //       closeAction ?? () => Navigator.pop(context, false),
                  //   child: Text(
                  //     cancelButtonText ?? 'CANCELAR',
                  //     style: const TextStyle(
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // ),

                  // FilledButton(
                  //   style: FilledButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(buttonBorderRadiusValue),
                  //     ),
                  //   ),
                  //   onPressed: actionSuccess,
                  //   child: Text(
                  //     confirmButtonText ?? 'CONFIRMAR',
                  //     style: const TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 10,
                  //     ),
                  //   ),
                  // )
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
      title: Text(
        'No hay conexión a internet',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text('Intenta conectarte a una red wifi o móvil'),
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
            // color: Colors.white,
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
