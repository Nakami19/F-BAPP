import 'package:f_bapp/common/data/constants.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:f_bapp/common/widgets/inputs/filter_container.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/shared/pagination.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/config/theme/business_app_colors.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/custom_navbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ListMobilePayments extends StatefulWidget {
  const ListMobilePayments({super.key});

  @override
  State<ListMobilePayments> createState() => _ListMobilePaymentsState();
}

class _ListMobilePaymentsState extends State<ListMobilePayments> {
  final GlobalKey<ScaffoldState> _listmobilepaymentScaffoldKey =
      GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> filterIcons = [];

  String? dropdownValueStatus;
  String? dropdownValueIssuinBank;
  String? dropdownValueReceivingBank;
  String status = "";
  String issuinBank = "";
  String receivingBank = "";
  late TextEditingController dateController;
  late TextEditingController idController;
  late TextEditingController phoneController;
  String id = "";
  String endDate = "";
  String startDate = "";
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: "");
    idController = TextEditingController(text: "");
    phoneController = TextEditingController(text: "");

    filterIcons = [
      {'icon': Icons.download_rounded, 'onPressed': () {}},
      {
        'icon': Icons.refresh_rounded,
        'onPressed': refreshPayments,
      },
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      paginationProvider.resetPagination();

      //peticiones para obtener la lista de devoluciones y la lista de estatus
      await merchantProvider.listMobilePaymentsStatus();
      await merchantProvider.getlistBanks();
      await merchantProvider.listMobilePayments(
        limit: 5,
        page: 0,
      );

      //el total de elementos para la paginacion sera igual a la cantidad de devoluciones que halla
      if (merchantProvider.payments != null) {
        paginationProvider.setTotal(merchantProvider.payments!['count']);
      }
    });
  }

  void resetFilters() async {
    final paginationProvider = context.read<PaginationProvider>();
    final merchantProvider = context.read<MerchantProvider>();
    setState(() {
      dateController.text = "";
      phoneController.text = "";
      idController.text = "";
      dropdownValueStatus = null;
      dropdownValueReceivingBank = null;
      dropdownValueIssuinBank = null;
    });

    endDate = "";
    startDate = "";
    status = "";
    id = "";
    phoneNumber = "";
    issuinBank = "";
    receivingBank = "";

    await merchantProvider.listMobilePayments(
      limit: 5,
      page: 0,
      endDate: endDate,
      idIssuingBank: issuinBank,
      idReceivingBank: receivingBank,
      idStatus: status,
      startDate: startDate,
      issuingPhone: phoneNumber,
      transactionNumber: id,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.payments!['count']);
  }

  void applyFilters() async {
    final paginationProvider = context.read<PaginationProvider>();

    // Procesar filtros aquí
    status = dropdownValueStatus ?? "";
    issuinBank = dropdownValueIssuinBank ?? "";
    receivingBank = dropdownValueReceivingBank ?? "";
    id = idController.text;
    phoneNumber = phoneController.text;
    endDate =
        dateController.text != "" ? dateController.text.split(" - ")[1] : "";
    startDate =
        dateController.text != "" ? dateController.text.split(" - ")[0] : "";

    //se hace la peticion con los filtros aplicados
    final merchantProvider = context.read<MerchantProvider>();

    await merchantProvider.listMobilePayments(
      limit: 5,
      page: 0,
      endDate: endDate,
      idIssuingBank: issuinBank,
      idReceivingBank: receivingBank,
      idStatus: status,
      startDate: startDate,
      issuingPhone: phoneNumber,
      transactionNumber: id,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.payments!['count']);
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
      CustomTextFormField(
        controller: idController,
        hintText: 'Nro de referencia',
        hintStyle:
            textStyle.bodySmall!.copyWith(fontSize: 17, color: Colors.grey),
        enabled: true,
      ),
      CustomTextFormField(
          controller: phoneController,
          hintText: 'Teléfono emisor',
          inputType: TextInputType.number,
          maxLength: 11,
          hintStyle:
              textStyle.bodySmall!.copyWith(fontSize: 17, color: Colors.grey),
          enabled: true,
          validator: (value) {
            if (value != null && value != "") {
              if (value.length < 11) {
                return 'El formato no es válido ';
              }

              if (phoneRegex.hasMatch(value.trim())) {
                return 'El código de área no es válido';
              }
            }

            return null;
          }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CustomDropdown(
          hintText: 'Estado',
          options: merchantProvider.status ?? [],
          onChanged: (value) {
            setState(() {
              dropdownValueStatus = value;
            });
          },
          selectedValue: dropdownValueStatus,
          itemValueMapper: (option) => option['idStatus']!,
          itemLabelMapper: (option) =>
              utilsProvider.capitalize(option['name']!),
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CustomDropdown(
          hintText: 'Banco emisor',
          options: merchantProvider.banks ?? [],
          onChanged: (value) {
            setState(() {
              dropdownValueIssuinBank = value;
            });
          },
          selectedValue: dropdownValueIssuinBank,
          itemValueMapper: (option) => option['bankId']!,
          itemLabelMapper: (option) =>
              utilsProvider.capitalize(option['bankDescription']!),
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CustomDropdown(
          hintText: 'Banco receptor',
          options: merchantProvider.banks ?? [],
          onChanged: (value) {
            setState(() {
              dropdownValueReceivingBank = value;
            });
          },
          selectedValue: dropdownValueReceivingBank,
          itemValueMapper: (option) => option['bankId']!,
          itemLabelMapper: (option) =>
              utilsProvider.capitalize(option['bankDescription']!),
          autoSelectFirst: false,
          optionsTextsStyle: textStyle.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: DateInput(
          controller: dateController,
          rangeDate: true,
          hintText: 'Fechas relevantes',
        ),
      ),
    ];

    return Scaffold(
      drawer: DrawerMenu(),
      key: _listmobilepaymentScaffoldKey,
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
            title: 'Listado de pagos móviles',
            screenKey: _listmobilepaymentScaffoldKey,
            poproute: merchantScreen,
          )),
      body: Column(
        children: [
          //No ha cargado
          if (merchantProvider.isLoading ||
              merchantProvider.payments == null ||
              merchantProvider.status == null ||
              merchantProvider.banks == null) ...[
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
              merchantProvider.payments != null &&
              merchantProvider.status != null &&
              merchantProvider.banks != null) ...[
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
                          '${DataConstant.imagesChinchin}/no-data.svg',
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
              //filtro
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
                          onTap: () {
                            // merchantProvider.refundInfo = refund;
                            merchantProvider.paymentInfo = payment;

                            merchantProvider.paymentInfo!['popRoute'] =
                                listmobilepaymentsScreen;
                            Map<String, dynamic> status =
                                merchantProvider.status!.firstWhere(
                              (status) =>
                                  status["idStatus"] == payment['idStatus'],
                            );

                            merchantProvider.paymentInfo!['status'] =
                                status['name'];
                            Navigator.pushNamed(
                              context,
                              paymentDetail,
                            );
                          },
                        ),
                      );
                    }),
              ),

              //Paginacion
              Pagination(
                //Funcion al pasar a la siguiente pagina
                onNextPressed: () {
                  merchantProvider.listMobilePayments(
                    limit: 5,
                    page: paginationProvider.page,
                    endDate: endDate,
                    idIssuingBank: issuinBank,
                    idReceivingBank: receivingBank,
                    idStatus: status,
                    startDate: startDate,
                    issuingPhone: phoneNumber,
                    transactionNumber: id,
                  );
                },

                //Funcion al pasar a la pagina anterior
                onPreviousPressed: () {
                  merchantProvider.listMobilePayments(
                    limit: 5,
                    page: paginationProvider.page,
                    endDate: endDate,
                    idIssuingBank: issuinBank,
                    idReceivingBank: receivingBank,
                    idStatus: status,
                    startDate: startDate,
                    issuingPhone: phoneNumber,
                    transactionNumber: id,
                  );
                },
              )
            ],
          ],
        ],
      ),
    );
  }

  void refreshPayments() async {
    final paginationProvider = context.read<PaginationProvider>();
    final merchantProvider = context.read<MerchantProvider>();

    merchantProvider.listMobilePayments(
      limit: 5,
      page: paginationProvider.page,
      endDate: endDate,
      idIssuingBank: issuinBank,
      idReceivingBank: receivingBank,
      idStatus: status,
      startDate: startDate,
      issuingPhone: phoneNumber,
      transactionNumber: id,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.payments!['count']);
  }

  List<Map<String, dynamic>> buildTextsFromPayments(
      Map<String, dynamic> payment, Map<String, Color> statusColors) {
    List<Map<String, dynamic>> objects = [];
    final merchantProvider = context.read<MerchantProvider>();

    Map<String, dynamic> status = merchantProvider.status!.firstWhere(
      (status) => status["idStatus"] == payment['idStatus'],
    );

    payment['idStatus'];

    if (payment['transactionNumber'] != null) {
      objects.add({
        'label': 'Número de referencia: ',
        'value': payment['transactionNumber']
      });
    }

    if (payment['issuingPhone'] != null) {
      objects.add(
          {'label': 'Teléfono emisor: ', 'value': payment['issuingPhone']});
    }

    if (payment['issuingBankName'] != null) {
      objects.add(
          {'label': 'Banco emisor: ', 'value': payment['issuingBankName']});
    }

    if (payment['receivingBankName'] != null) {
      objects.add(
          {'label': 'Banco receptor: ', 'value': payment['receivingBankName']});
    }

    if (payment['createdDate'] != null) {
      objects.add({
        'label': 'Fecha: ',
        'value':
            DateFormatter.formatDate(DateTime.parse(payment['createdDate']))
      });
    }

    if (payment['amount'] != null) {
      objects.add({
        'label': 'Monto: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(payment['amount'])} ${payment['prefixCurrency']}'
      });
    }

    objects.add({
      'label': 'status',
      'value': status['name'],
      'statusColor': statusColors[status['name']]
    });

    return objects;
  }
}
