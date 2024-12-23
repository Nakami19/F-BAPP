import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/widgets/cards/information_card.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevolutionDetailScreen extends StatefulWidget {
  const DevolutionDetailScreen({super.key});

  @override
  State<DevolutionDetailScreen> createState() => _DevolutionDetailScreenState();
}

class _DevolutionDetailScreenState extends State<DevolutionDetailScreen> {
  final GlobalKey<ScaffoldState> _devolutionScaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

     final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final merchantProvider = context.watch<MerchantProvider>();
    
    return Scaffold(

drawer: DrawerMenu(),
        key: _devolutionScaffoldKey,
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
              title: 'Detalle de devolución',
              screenKey: _devolutionScaffoldKey,
              poproute: listmerchantdevolutionsScreen,
            )),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [

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
        

                //Card con la informacion de la orden
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: InformationCard(
                    title: "#${merchantProvider.refundInfo!["idPaymentAttempt"]}",
                    subtitle: merchantProvider.refundInfo!['createdDate'] != null
                        ? 'Fecha de creacion: ${DateFormatter.formatDate(DateTime.parse(merchantProvider.refundInfo!['createdDate']))}'
                        : "",
                    texts: buildTextsFromDetail(
                         merchantProvider.refundInfo!),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

              ],
            ]),
          ),
        ),
    );
  }

   List<Map<String, dynamic>> buildTextsFromDetail(Map<String, dynamic> refund) {
    List<Map<String, dynamic>> objects = [];
    final utilsProvider = context.read<UtilsProvider>();

    if (refund['idOrder'] != null) {
      objects.add({
        'label': 'Nro. de orden: ',
        'value': refund['idOrder']
      });
    }

     if (refund['phoneNumber'] != null) {
      objects.add({
        'label': 'Nro. de teléfono: ',
        'value': refund['phoneNumber']
      });
    }

    if (refund['amount'] != null) {
      objects.add({
        'label': 'Monto: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(refund['amount'].toString())} BS'
      });
    }

    if (refund['totalAmount'] != null) {
      objects.add({
        'label': 'Monto total: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(refund['totalAmount'].toString())} BS'
      });
    }

    if (refund['totalCommission'] != null) {
      objects.add({
        'label': 'Comisión: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(refund['totalCommission'].toString())} BS'
      });
    }

    if (refund['namePaymentMethod'] != null) {
      objects.add({
        'label': 'Método de pago: ',
        'value': refund['namePaymentMethod'] 
      });
    }

    if (refund['namePaymentType'] != null) {
      objects.add({
        'label': 'Tipo de pago: ',
        'value': refund['namePaymentType'] 
      });
    }

    if (refund['status'] != null) {
      objects.add({
        'label': 'Estado: ',
        'value': utilsProvider.capitalize(refund['status'])  
      });
    }


    return objects;
  }
}