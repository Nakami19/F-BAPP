import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:f_bapp/common/widgets/inputs/filter_container.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/shared/pagination.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/config/theme/business_app_colors.dart';
import 'package:f_bapp/presentation/providers/modules/merchant/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ListOrdersScreen extends StatefulWidget {
  const ListOrdersScreen({super.key});

  @override
  State<ListOrdersScreen> createState() => _ListOrdersScreenState();
}

class _ListOrdersScreenState extends State<ListOrdersScreen> {
  final GlobalKey<ScaffoldState> _listordersScaffoldKey =
      GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();

//Controladores para los inputs del filtro
  late TextEditingController idController;
  late TextEditingController dateController;

  //Variables del filtro de busqueda
  String? dropdownValue;
  String status = "";
  String id = "";
  String endDate = DateFormatter.formatDate2(DateTime.now()).toString();
  String startDate = DateFormatter.formatDate2(DateTime.now()).toString();

  List<Map<String, dynamic>> filterIcons = [];

  @override
  void initState() {
    super.initState();

    idController = TextEditingController();
    dateController = TextEditingController(text: '$startDate - $endDate');

    final userProvider = context.read<UserProvider>();

    if (userProvider.verificationPrivileges('download_merchant_orders')) {
      filterIcons.add({'icon': Icons.download_rounded, 'onPressed': () {}});
    }

    filterIcons.add(
      {
        'icon': Icons.refresh_rounded,
        'onPressed': refreshOrders,
      },
    );
    final merchantProvider = context.read<MerchantProvider>();
    merchantProvider.setOrders = null;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      //se reinicia la paginacion
      paginationProvider.resetPagination();

      //peticiones para obtener la lista de ordenes y la lista de estatus
      await merchantProvider.listStatus('ORDER');
      await merchantProvider.listorders(
          limit: 5,
          page: 0,
          startDate: DateFormatter.formatDate2(DateTime.now()).toString(),
          endDate: DateFormatter.formatDate2(DateTime.now()).toString());

      //el total de elementos para la paginacion sera igual a la cantidad de ordenes que halla
      if (merchantProvider.orders != null) {
        paginationProvider.setTotal(merchantProvider.orders!['count']);
      }
    });
  }

  @override
  void dispose() {
    idController.dispose();
    dateController.dispose();
    super.dispose();
  }

  //Reinicio de los valores de los filtros
  void resetFilters() async {
    final paginationProvider = context.read<PaginationProvider>();
    final merchantProvider = context.read<MerchantProvider>();

    setState(() {
      idController.clear();
      dateController.text =
          '${DateFormatter.formatDate2(DateTime.now()).toString()} - ${DateFormatter.formatDate2(DateTime.now()).toString()}';
      dropdownValue = null;
    });

    status = "";
    id = "";
    endDate = DateFormatter.formatDate2(DateTime.now()).toString();
    startDate = DateFormatter.formatDate2(DateTime.now()).toString();

    await merchantProvider.listorders(
        page: 0,
        limit: 5,
        startDate: startDate,
        endDate: endDate,
        idOrder: id,
        tagStatus: status);

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.orders!['count']);
  }

  void applyFilters() async {
    final paginationProvider = context.read<PaginationProvider>();

    // Procesar filtros aquí
    status = dropdownValue ?? "";
    id = idController.text;
    endDate = dateController.text.split(" - ")[1];
    startDate = dateController.text.split(" - ")[0];

    //se hace la peticion con los filtros aplicados
    final merchantProvider = context.read<MerchantProvider>();
    await merchantProvider.listorders(
        page: 0,
        limit: 5,
        startDate: startDate,
        endDate: endDate,
        idOrder: id,
        tagStatus: status);

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.orders!['count']);
  }

  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();
    final utilsProvider = context.watch<UtilsProvider>();
    final textStyle = Theme.of(context).textTheme;
    final userProvider = context.read<UserProvider>();

    //Componentes que tendra el filtro
    final List<Widget> filters = [
      CustomTextFormField(
          controller: idController,
          hintText: 'Buscar id',
          hintStyle:
              textStyle.bodySmall!.copyWith(fontSize: 17, color: Colors.grey),
          enabled: true,
          validator: (value) {
            if (value != null && value != "") {
              if (value.length != 24) {
                return 'La cantidad de caracteres permitidos es 24';
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
              dropdownValue = value;
            });
          },
          selectedValue: dropdownValue,
          itemValueMapper: (option) => option['tagStatus']!,
          itemLabelMapper: (option) =>
              utilsProvider.capitalize(option['nameStatus']!),
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

    return WillPopScope(
      onWillPop: () async {
        merchantProvider.disposeValues();
        return true;
      },
      child: Scaffold(
        drawer: DrawerMenu(),
        key: _listordersScaffoldKey,
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
              title: 'Listado de ordenes',
              screenKey: _listordersScaffoldKey,
              poproute: merchantScreen,
              onBack: () {
                merchantProvider.disposeValues();
              },
            )),
        body: Column(
          children: [
            //Si esta cargando o no se tienen valores de los estatus o las ordenes
            if (merchantProvider.isLoading == true ||
                merchantProvider.status == null ||
                merchantProvider.orders == null) ...[
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
                child: CustomSkeleton(height: 140),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: CustomSkeleton(height: 140),
              ),
              const SizedBox(
                height: 15,
              ),
            ],

            //Ya cargo
            if (merchantProvider.isLoading == false &&
                merchantProvider.orders != null) ...[
              //Si no hay ordenes
              if (merchantProvider.orders?['count'] == 0) ...[
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

              //si hay ordenes
              if (merchantProvider.orders!['count'] > 0) ...[
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

                //Tarjetas con informacion de las ordenes
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: merchantProvider.orders!['rows'].length,
                      itemBuilder: (context, index) {
                        final order = merchantProvider.orders!['rows'][index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          child: TextCard(
                            texts: buildTextsFromOrder(order,
                                statusColors), // Lista con los textos generada
                            onTap: () {
                              if (userProvider.verificationPrivileges(
                                  'order_report_detail')) {
                                merchantProvider.infoOrder = order;
                                Navigator.pushNamed(
                                  context,
                                  '/Detalle de orden',
                                  arguments: order['idOrder'],
                                );
                              }
                            },
                          ),
                        );
                      }),
                ),

                //Paginacion
                Pagination(
                  //Funcion al pasar a la siguiente pagina
                  onNextPressed: () {
                    merchantProvider.listorders(
                        page: paginationProvider.page,
                        limit: 5,
                        startDate: startDate,
                        endDate: endDate,
                        idOrder: id,
                        tagStatus: status);

                    if (status != "") {
                      dropdownValue = status;
                    } else {
                      dropdownValue = null;
                    }
                    idController.text = id;

                    if (startDate != "" && endDate != "") {
                      dateController.text = '$startDate - $endDate';
                    } else {
                      dateController.text = '${DateFormatter.formatDate2(DateTime.now()).toString()} - ${DateFormatter.formatDate2(DateTime.now()).toString()}';
                    }
                  },

                  //Funcion al pasar a la pagina anterior
                  onPreviousPressed: () {
                    merchantProvider.listorders(
                        page: paginationProvider.page,
                        limit: 5,
                        startDate: startDate,
                        endDate: endDate,
                        idOrder: id,
                        tagStatus: status);

                        if (status != "") {
                      dropdownValue = status;
                    } else {
                      dropdownValue = null;
                    }
                    idController.text = id;

                    if (startDate != "" && endDate != "") {
                      dateController.text = '$startDate - $endDate';
                    } else {
                      dateController.text = '';
                    }
                  },
                )
              ]
            ]
          ],
        ),
      ),
    );
  }

  //Se contruye el contenido de la lista textos que tendra la tarjeta
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
            '${DigitFormatter.getMoneyFormatter(order['amount'].toString())} ${order['tagCurrency']}'
      });
    }

    objects.add({
      'label': 'status',
      'value': order['status'],
      'statusColor': statusColors[order['status']]
    });

    return objects;
  }

  void refreshOrders() async {
    final merchantProvider = context.read<MerchantProvider>();
    final paginationProvider = context.read<PaginationProvider>();

    // Llama a la API para obtener las transacciones nuevamente
    await merchantProvider.listorders(
        page: 0,
        limit: 5,
        startDate: startDate,
        endDate: endDate,
        idOrder: id,
        tagStatus: status);

    // Reinicia la paginación
    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.payments!['count']);
  }
}
