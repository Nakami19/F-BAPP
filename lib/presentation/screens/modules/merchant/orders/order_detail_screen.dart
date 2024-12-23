import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/buttons/custom_button.dart';
import 'package:f_bapp/common/widgets/cards/information_card.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final GlobalKey<ScaffoldState> _orderScaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic>? order = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();

      order = await merchantProvider.orderDetail(
          merchantProvider.orderInfo?["idOrder"] ?? widget.orderId);

      merchantProvider.userData = order!['payingUserInformation'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final merchantProvider = context.watch<MerchantProvider>();

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
                              onTap: () {},
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
                                onTap: () {},
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
                      Navigator.pushNamed(context, userdetailScreen,
                          arguments: widget.orderId);
                    },
                    texts: buildTextsFromOrder(
                        order ?? merchantProvider.infoOrder!),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //Indicador para ir a vista de historial de pagos
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Historial de pagos',
                          arguments: widget.orderId);
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
        ));
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
}
