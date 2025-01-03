import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/widgets/cards/information_card.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({super.key});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final GlobalKey<ScaffoldState> _paymentScaffoldKey =
      GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();

    return Scaffold(
      drawer: DrawerMenu(),
      key: _paymentScaffoldKey,
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
            title: 'Detalle de pago',
            screenKey: _paymentScaffoldKey,
            poproute:
                merchantProvider.paymentInfo!['popRoute'] ?? merchantScreen,
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
              //Card con la informacion del pago
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InformationCard(
                  title: merchantProvider.paymentInfo!["idPaymentAttempt"] !=
                          null
                      ? "#${merchantProvider.paymentInfo!["idPaymentAttempt"]}"
                      : "#${merchantProvider.paymentInfo!["transactionNumber"]}}",
                  subtitle: merchantProvider.paymentInfo!['createdDate'] != null
                      ? 'Fecha de creacion: ${DateFormatter.formatDate(DateTime.parse(merchantProvider.paymentInfo!['createdDate']))}'
                      : 'Fecha de creacion: ${DateFormatter.formatDate(DateTime.parse(merchantProvider.paymentInfo!['createDate']))}',
                  texts: buildTextsFromDetailPayment(
                      merchantProvider.paymentInfo!),
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

  List<Map<String, dynamic>> buildTextsFromDetailPayment(
      Map<String, dynamic> payment) {
    List<Map<String, dynamic>> objects = [];
    final utilsProvider = context.read<UtilsProvider>();

    if (payment['typeTxName'] != null) {
      objects.add(
          {'label': 'Tipo de transacción: ', 'value': payment['typeTxName']});
    }

    if (payment['issuingBankName'] != null) {
      objects.add(
          {'label': 'Banco emisor: ', 'value': payment['issuingBankName']});
    }

    if (payment['receivingBankName'] != null) {
      objects.add(
          {'label': 'Banco receptor: ', 'value': payment['receivingBankName']});
    }

    if (payment['issuingPhone'] != null) {
      objects.add(
          {'label': 'Teléfono emisor: ', 'value': payment['issuingPhone']});
    }

    if (payment['receivingPhone'] != null) {
      objects.add(
          {'label': 'Teléfono receptor: ', 'value': payment['receivingPhone']});
    }

    if (payment['description'] != null) {
      objects.add({'label': 'Descripción: ', 'value': payment['description']});
    }

    if (payment['phoneNumber'] != null) {
      objects.add(
          {'label': 'Nro. de teléfono: ', 'value': payment['phoneNumber']});
    }

    if (payment['idOrder'] != null) {
      objects.add({'label': 'Nro. de orden: ', 'value': payment['idOrder']});
    }

    if (payment['idPaymentAttempt'] != null) {
      objects.add(
          {'label': 'Nro. de pago: ', 'value': payment['idPaymentAttempt']});
    }

    if (payment['namePaymentMethod'] != null) {
      objects.add(
          {'label': 'Método de pago: ', 'value': payment['namePaymentMethod']});
    }

    if (payment['namePaymentType'] != null) {
      objects.add(
          {'label': 'Tipo de pago: ', 'value': payment['namePaymentType']});
    }

    if (payment['status'] != null) {
      objects.add({
        'label': 'Estado: ',
        'value': utilsProvider.capitalize(payment['status'])
      });
    }

    if (payment['amount'] != null) {
      objects.add({
        'label': 'Monto: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['amount'].toString())} BS'
      });
    }

    if (payment['totalAmount'] != null) {
      objects.add({
        'label': 'Monto total: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['totalAmount'].toString())} BS'
      });
    }

    if (payment['totalCommission'] != null) {
      objects.add({
        'label': 'Comisión: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['totalCommission'].toString())} BS'
      });
    }

    return objects;
  }
}
