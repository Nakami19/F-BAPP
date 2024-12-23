import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:f_bapp/common/widgets/inputs/filter_container.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/shared/pagination.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/config/theme/business_app_colors.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  String? dropdownValue2;
  String tagstatus = "";
  String paymentType = "";
  late TextEditingController dateController;

  String endDate = "";
  String startDate = "";

  List<Map<String, dynamic>> filterIcons = [];

  List<dynamic>? typePayment = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController = TextEditingController(text: "");

    filterIcons = [
      {
        'icon': Icons.refresh_rounded,
        'onPressed': refreshTransactions,
      },
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      //se reinicia la paginacion
      paginationProvider.resetPagination();

      //peticiones para obtener  la lista de estatus
      await merchantProvider.listStatus('PAYMENT');

      typePayment = await merchantProvider.typePayment();

      await merchantProvider.getTransactionsList(
        limit: 5,
        page: 0,
        idOrder: merchantProvider.orderInfo?["idOrder"],
      );

      //el total de elementos para la paginacion sera igual a la cantidad elementos que halla

      if (merchantProvider.payments != null) {
        paginationProvider.setTotal(merchantProvider.payments!['count']);
      }
    });
  }

//Reinicio de los valores de los filtros
  void resetFilters() {
    setState(() {
      dateController.text = "";
      dropdownValue = null;
      dropdownValue2 = null;
    });
  }

  void applyFilters() async {
    final paginationProvider = context.read<PaginationProvider>();

    // Procesar filtros aquí
    tagstatus = dropdownValue ?? "";
    paymentType = dropdownValue2 ?? "";
    endDate = dateController.text!=""? dateController.text.split(" - ")[1] : "";
    startDate = dateController.text!=""? dateController.text.split(" - ")[0]: "";

    //se hace la peticion con los filtros aplicados
    final merchantProvider = context.read<MerchantProvider>();
    await merchantProvider.getTransactionsList(
        idOrder: merchantProvider.orderInfo?["idOrder"],
        limit: 5,
        page: 0,
        idPaymentType: paymentType,
        tagStatus: tagstatus,
        endDate: endDate,
        startDate: startDate);

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.orders!['count']);
  }

  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final textStyle = Theme.of(context).textTheme;
    final merchantProvider = context.watch<MerchantProvider>();
    final utilsProvider = context.watch<UtilsProvider>();

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
          itemLabelMapper: (option) => utilsProvider.capitalize(option['nameStatus']!),
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
              dropdownValue2 = value;
            });
          },
          selectedValue: dropdownValue2,
          itemValueMapper: (option) => option['tag']!,
          itemLabelMapper: (option) => utilsProvider.capitalize(option['name']!),
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: DateInput(
          controller: dateController,
          rangeDate: true,
          hintText: 'Fechas de relevantes',
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
          if (merchantProvider.isLoading ||
              merchantProvider.payments == null ||
              merchantProvider.status == null) ...[
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
          if (!merchantProvider.isLoading &&
              merchantProvider.payments != null) ...[
            Center(
              child: Text("#${widget.id}",
                  style: textStyle.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600)),
            ),
            if (merchantProvider.payments?['count'] == 0) ...[
              //Filtro
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Filter(
                  icons: filterIcons.map((iconConfig) {
                    return IconButton(
                      icon: Icon(iconConfig['icon']),
                      onPressed: iconConfig['onPressed'],
                    );
                  }).toList(),
                  inputs: filters,
                  onReset: resetFilters,
                  onApply: applyFilters,
                ),
              ),

              //Aviso
              Expanded(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/chinchin/no_data.svg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(child: Text('No hay datos disponibles')),
                    ],
                  ),
                ),
              )
            ],
            if (merchantProvider.payments!['count'] > 0) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Filter(
                  icons: filterIcons.map((iconConfig) {
                    return IconButton(
                      icon: Icon(iconConfig['icon']),
                      onPressed: iconConfig['onPressed'],
                    );
                  }).toList(),
                  inputs: filters,
                  onReset: resetFilters,
                  onApply: applyFilters,
                ),
              ),

              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: merchantProvider.payments!['rows'].length,
                    itemBuilder: (context, index) {
                      final payment = merchantProvider.payments!['rows'][index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 35),
                        child: TextCard(
                          texts: buildTextsFromPayments(payment,
                              statusColors), // Lista con los textos generada
                          onTap: () {},
                        ),
                      );
                    }),
              ),

              //Paginacion
              Pagination(
                //Funcion al pasar a la siguiente pagina
                onNextPressed: () {
                  merchantProvider.getTransactionsList(
                      limit: 5,
                      page: paginationProvider.page,
                      idOrder: merchantProvider.orderInfo?["idOrder"],
                      tagStatus: tagstatus,
                      idPaymentType: paymentType,
                      startDate: startDate);
                },

                //Funcion al pasar a la pagina anterior
                onPreviousPressed: () {
                  merchantProvider.getTransactionsList(
                      limit: 5,
                      page: paginationProvider.page,
                      idOrder: merchantProvider.orderInfo?["idOrder"],
                      tagStatus: tagstatus,
                      idPaymentType: paymentType,
                      startDate: startDate);
                },
              )
            ],
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> buildTextsFromPayments(
      Map<String, dynamic> payment, Map<String, Color> statusColors) {
    List<Map<String, dynamic>> objects = [];

    if (payment['idPaymentAttempt'] != null) {
      objects.add({'label': 'Id pago: ', 'value': payment['idPaymentAttempt']});
    }

    if (payment['amount'] != null) {
      objects.add({
        'label': 'Monto: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['amount'].toString())} ${payment['nameCurrency']}'
      });
    }

    if (payment['totalAmount'] != null) {
      objects.add({
        'label': 'Monto total: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['totalAmount'].toString())} ${payment['nameCurrency']}'
      });
    }

    if (payment['totalCommission'] != null) {
      objects.add({
        'label': 'Comisión: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['totalCommission'].toString())} ${payment['nameCurrency']}'
      });
    }

    if (payment['createdDate'] != null) {
      objects.add({
        'label': 'Fecha: ',
        'value':
            '${DateFormatter.formatDate(DateTime.parse(payment['createdDate']))}'
      });
    }

    objects.add({
      'label': 'status',
      'value': payment['status'],
      'statusColor': statusColors[payment['status']]
    });

    return objects;
  }

  void refreshTransactions() async {
    final merchantProvider = context.read<MerchantProvider>();
    final paginationProvider = context.read<PaginationProvider>();

    // Llama a la API para obtener las transacciones nuevamente
    await merchantProvider.getTransactionsList(
      idOrder: merchantProvider.orderInfo?["idOrder"],
      limit: 5,
      page: 0,
      tagStatus: tagstatus,
      startDate: startDate,
    );

    // Reinicia la paginación
    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.payments!['count']);
  }
}
