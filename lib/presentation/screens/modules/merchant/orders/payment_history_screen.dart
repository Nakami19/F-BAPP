import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:f_bapp/common/widgets/inputs/filter_container.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key, required this.id});

  final String id;
  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final GlobalKey<ScaffoldState> _paymentHistoryScaffoldKey =
      GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();

  String? dropdownValue;
  late TextEditingController dateController;

  String endDate = DateFormatter.formatDate2(DateTime.now()).toString();
  String startDate = DateFormatter.formatDate2(DateTime.now()).toString();

  List<Map<String, dynamic>> filterIcons = [
    {'icon': Icons.refresh_rounded, 'onPressed': () {}}
  ];

  List<dynamic>? typePayment = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController = TextEditingController(text: '$startDate - $endDate');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      //se reinicia la paginacion
      // paginationProvider.resetPagination();

      //peticiones para obtener  la lista de estatus
      await merchantProvider.listStatus('PAYMENT');

      typePayment = await merchantProvider.typePayment();

      //el total de elementos para la paginacion sera igual a la cantidad de ordenes que halla
    });
  }

//Reinicio de los valores de los filtros
  void resetFilters() {
    setState(() {
      dateController.text =
          '${DateFormatter.formatDate2(DateTime.now()).toString()} - ${DateFormatter.formatDate2(DateTime.now()).toString()}';
      dropdownValue = null;
    });
  }

  void applyFilters() async {}

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final merchantProvider = context.watch<MerchantProvider>();

    //Componentes que tendra el filtro
    final List<Widget> filters = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CustomDropdown(
          hintText: 'Estado',
          options: merchantProvider.status ?? [],
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
          },
          selectedValue: dropdownValue,
          itemValueMapper: (option) => option['tagStatus']!,
          itemLabelMapper: (option) => option['nameStatus']!,
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CustomDropdown(
          hintText: 'Tipo de pago',
          options: typePayment ?? [],
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
          },
          selectedValue: dropdownValue,
          itemValueMapper: (option) => option['tag']!,
          itemLabelMapper: (option) => option['name']!,
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: DateInput(
          controller: dateController,
          rangeDate: true,
          hintText: 'Fecha de emision',
        ),
      ),
    ];

    return Scaffold(
      drawer: DrawerMenu(),
      key: _paymentHistoryScaffoldKey,
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
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
            title: 'Historial de pagos',
            screenKey: _paymentHistoryScaffoldKey,
          )),
      body: Column(
        children: [

          //No ha cargado
          if (merchantProvider.isLoading) ...[
            const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Center(
                  child: CustomSkeleton(
                    height: 65,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: CustomSkeleton(height: 160),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: CustomSkeleton(height: 160),
              ),
          ],


          //Ya cargo
          if (!merchantProvider.isLoading) ...[
            Center(
              child: Text("#${widget.id}",
                  style: textStyle.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Filter(
                icons: filterIcons,
                inputs: filters,
                onReset: resetFilters,
                onApply: applyFilters,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 35),
                      child: TextCard(
                        texts: [
                          {
                            'label': 'id: ',
                            'value':
                                '676597d4a00d5c4307c9b61e'
                          },
                          {'label': 'Monto: ', 'value': '100'},
                          {'label': 'Comision: ', 'value': '2'},
                          {'label': 'Fecha: ', 'value': '19/12/2024 5:46 PM'},
                          {
                            'label': 'Metodo de pago: ',
                            'value': 'Transferencia inmediata'
                          },
                          {'label': 'Tipo de pago: ', 'value': 'pasarela'},
                          {
                            'label': 'status',
                            'value': 'Rechazado',
                            'statusColor': Colors.red
                          },
                        ],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/Detalle de orden',
                          );
                        },
                      ),
                    );
                  }),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> buildTextsFromOrder(
      Map<String, dynamic> order, Map<String, Color> statusColors) {
    List<Map<String, dynamic>> objects = [];

    if (order['idOrder'] != null) {
      objects.add({'label': 'ID Orden: ', 'value': order['idOrder']});
    }

    if (order['createdDate'] != null) {
      objects.add({
        'label': 'Fecha: ',
        'value':
            '${DateFormatter.formatDate(DateTime.parse(order['createdDate']))}'
      });
    }

    if (order['amount'] != null) {
      objects.add({
        'label': 'Monto: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(order['amount'].toString())} BS'
      });
    }

    objects.add({
      'label': 'status',
      'value': order['status'],
      'statusColor': statusColors[order['status']]
    });

    return objects;
  }
}
