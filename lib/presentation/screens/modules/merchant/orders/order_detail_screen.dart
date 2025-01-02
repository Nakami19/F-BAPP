import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/cards/information_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/shared/snackbars.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/session_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/app_dialogs.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final GlobalKey<ScaffoldState> _orderScaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  //detalle de la orden
  Map<String, dynamic>? order = {};

  //Qr

  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  @protected
  late PrettyQrDecoration decoration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final sessionProvider = context.read<SessionProvider>();

      order = await merchantProvider.orderDetail(
          merchantProvider.orderInfo?["idOrder"]);

      merchantProvider.userData = order!['payingUserInformation'];

      sessionProvider.documentType();

      qrCode = QrCode.fromData(
        data: merchantProvider.orderInfo!['urlOrder'],
        errorCorrectLevel: QrErrorCorrectLevel.H,
      );

      qrImage = QrImage(qrCode);

      decoration = const PrettyQrDecoration(
        shape: PrettyQrSmoothSymbol(
          color: Colors.black,
          roundFactor: 0,
        ),
        background: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final merchantProvider = context.watch<MerchantProvider>();
    final userProvider = context.read<UserProvider>();

    return Scaffold(
        drawer: DrawerMenu(),
        key: _orderScaffoldKey,
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
              title: 'Detalle de orden',
              screenKey: _orderScaffoldKey,
              poproute: listmerchantordersScreen,
            )),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              if (merchantProvider.isLoading) ...[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: CustomSkeleton(
                          height: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Center(
                        child: CustomSkeleton(
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Center(
                    child: CustomSkeleton(
                      height: MediaQuery.of(context).size.height / 1.2,
                    ),
                  ),
                ),
              ],
              if (!merchantProvider.isLoading) ...[
                //Botones
                Row(
                  children: [
                  if(userProvider.verificationPrivileges('revert_order'))
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: CustomButton(
                              title: 'Reversar',
                              isPrimaryColor: false,
                              colorFilledButton: errorColor,
                              icon: Icons.refresh_rounded,
                              isOutline: false,
                              onTap: () {
                               AppDialogs.revertPopup(context, order!);
                              },
                              provider: GeneralProvider()),
                        ),
                      ),
                    ),

                    //Solo se muestra compartir para las ordenes activas
                    if (merchantProvider.orderInfo!['status'] == 'ACTIVO')
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: CustomButton(
                                title: 'Compartir',
                                isPrimaryColor: true,
                                icon: Icons.share,
                                iconColor: primaryColor,
                                isOutline: true,
                                onTap: () {
                                  sharePopup(context);
                                },
                                provider: GeneralProvider()),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),

                SizedBox(
                  height: 5,
                ),

                //Card con la informacion de la orden
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: InformationCard(
                    title: "#${order?["idOrder"]}",
                    subtitle: order!['createdDate'] != null
                        ? 'Fecha de creacion: ${DateFormatter.formatDate(DateTime.parse(order!['createdDate']))}'
                        : "",
                    nextPage: 'Datos del usuario',
                    nextPageRoute: userdetailScreen,
                    onTapnextPage: () {
                      Navigator.pushNamed(context, userdetailScreen);
                    },
                    texts: buildTextsFromOrder(
                        order ?? merchantProvider.infoOrder!),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //Indicador para ir a vista de historial de pagos
                if(userProvider.verificationPrivileges('order_report_payment_attempts'))
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Historial de pagos',
                          );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Historial de pagos",
                          style: textStyle.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                )
              ],
            ]),
          ),
        )
        );
  }

  List<Map<String, dynamic>> buildTextsFromOrder(Map<String, dynamic> order) {
    List<Map<String, dynamic>> objects = [];
    final merchantProvider = context.read<MerchantProvider>();

    if (order['amount'] != null) {
      objects.add({
        'label': 'Monto: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(order['amount'].toString())} BS'
      });
    }

    if (order['balance'] != null) {
      objects.add({
        'label': 'Balance: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(order['balance'].toString())} BS'
      });
    }

    if (order['delegateCommission'] != null) {
      objects.add({
        'label': 'Comisión delegada: ',
        'value': order['delegateCommission'] ? "Si" : "No"
      });
    }

    if (order['expirationDate'] != null) {
      objects.add({
        'label': 'Fecha de expiración: ',
        'value':
            DateFormatter.formatDate(DateTime.parse(order['expirationDate']))
      });
    }

    if (order['status'] != null) {
      objects.add({'label': 'Estatus: ', 'value': order['status']});
    }

    if (order['refundStatus'] != null) {
      objects.add(
          {'label': 'Estado de reverso: ', 'value': order['refundStatus']});
    }

    if (merchantProvider.orderInfo!['metadata'] != null &&
        merchantProvider.orderInfo!['metadata']["partnerName"] != null) {
      objects.add({
        'label': 'Sucursal: ',
        'value': merchantProvider.orderInfo!['metadata']["partnerName"]
      });
    }

    if (merchantProvider.orderInfo!['nameTypeOrder'] != null) {
      objects.add({
        'label': 'Tipo de pago: ',
        'value': merchantProvider.orderInfo!['nameTypeOrder']
      });
    }

    return objects;
  }

  void sharePopup(BuildContext context) {
    final merchantProvider = context.read<MerchantProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Boton para cerrar
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_rounded)),
                ),

                const Text(
                  "Compartir orden",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // QR
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: PrettyQrView(
                    qrImage: qrImage,
                    decoration: decoration,
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: CustomButton(
                      title: 'Compartir',
                      isPrimaryColor: true,
                      icon: Icons.share,
                      iconColor: primaryColor,
                      isOutline: true,
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: order!['urlOrder'] ??
                                merchantProvider.orderInfo!['urlOrder']));
                        Snackbars.customSnackbar(context,
                            message: 'Texto copiado al portapapeles');
                      },
                      provider: GeneralProvider()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void revertPopup(BuildContext context) {
  //   bool showFields = false; // Estado interno para mostrar o no los inputs.
  //   final sessionProvider = context.read<SessionProvider>();
  //   String? currentValue;
  //   TextEditingController documentController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12)),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Text(
  //                   'Se va a retornar los fondos a la cuenta correspondiente',
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 20),
  //                 const Text(
  //                   '¿Deseas intentar el reverso a una cédula distinta a la reportada por el cliente?',
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Radio<bool>(
  //                           value: true,
  //                           groupValue: showFields,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               showFields = value!;
  //                             });
  //                           },
  //                         ),
  //                         Text('Sí'),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         Radio<bool>(
  //                           value: false,
  //                           groupValue: showFields,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               showFields = value!;
  //                             });
  //                           },
  //                         ),
  //                         Text('No'),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 AnimatedSwitcher(
  //                   duration: Duration(milliseconds: 300),
  //                   child: showFields
  //                       ? Column(
  //                           children: [
  //                             SizedBox(height: 10),
  //                             Row(
  //                               children: [
  //                                 SizedBox(
  //                                   width: 80,
  //                                   child: Expanded(
  //                                     child: CustomDropdown(
  //                                         autoSelectFirst: true,
  //                                         options: sessionProvider
  //                                             .documentsType!
  //                                             .sublist(
  //                                                 1,
  //                                                 sessionProvider
  //                                                     .documentsType!.length),
  //                                         onChanged: (value) {
  //                                           setState(() {
  //                                             currentValue = value;
  //                                           });
  //                                         },
  //                                         selectedValue: currentValue,
  //                                         itemValueMapper: (option) =>
  //                                             option['documentTypeId']!,
  //                                         itemLabelMapper: (option) =>
  //                                             option['documentTypeName']!),
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                     child: CustomTextFormField(
  //                                         controller: documentController,
  //                                         inputType: TextInputType.number,
  //                                         hintText: 'CI/RIF',
  //                                         enabled: true,
  //                                         maxLength: 8,
  //                                         validator: (value) {
  //                                           if (value != null && value != "") {
  //                                             if (value.length < 8) {
  //                                               return 'El formato no es válido ';
  //                                             }
  //                                           }

  //                                           return null;
  //                                         })),
  //                               ],
  //                             ),
  //                             SizedBox(height: 10),
  //                           ],
  //                         )
  //                       : SizedBox.shrink(key: ValueKey('empty')),
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 5),
  //                         child: CustomButton(
  //                           title: 'CANCELAR',
  //                           isPrimaryColor: false,
  //                           isOutline: false,
  //                           isText: true,
  //                           width: 90,
  //                           paddingH: 0,
  //                           height: 50,
  //                           styleText: Theme.of(context)
  //                               .textTheme
  //                               .labelMedium!
  //                               .copyWith(
  //                                 color: Color.fromRGBO(252, 198, 20, 100),
  //                                 fontSize: 12,
  //                               ),
  //                           styleTextButton: TextButton.styleFrom(
  //                             side: const BorderSide(
  //                               color: Color.fromRGBO(252, 198, 20, 100),
  //                               width: 2,
  //                             ),
  //                           ),
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                           },
  //                           provider: GeneralProvider(),
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 5),
  //                         child: CustomButton(
  //                           title: 'Aceptar',
  //                           isPrimaryColor: true,
  //                           isOutline: false,
  //                           width: 90,
  //                           paddingH: 0,
  //                           height: 50,
  //                           onTap: () {
  //                             final merchantProvider =
  //                                 context.read<MerchantProvider>();

  //                             merchantProvider.revertOrder(
  //                                 idDocumentType: currentValue,
  //                                 documentNumber: documentController.text,
  //                                 idOrder: order?["idOrder"]);

  //                             Navigator.pop(context);
  //                           },
  //                           styleText: Theme.of(context)
  //                               .textTheme
  //                               .labelMedium!
  //                               .copyWith(
  //                                 color: Colors.white,
  //                                 fontSize: 13,
  //                               ),
  //                           provider: GeneralProvider(),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
