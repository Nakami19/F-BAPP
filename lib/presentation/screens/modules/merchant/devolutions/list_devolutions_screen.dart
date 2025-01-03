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
import 'package:f_bapp/presentation/providers/modules/merchant/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/user_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ListDevolutionsScreen extends StatefulWidget {
  const ListDevolutionsScreen({super.key});

  @override
  State<ListDevolutionsScreen> createState() => _ListDevolutionsScreenState();
}

class _ListDevolutionsScreenState extends State<ListDevolutionsScreen> {
  final GlobalKey<ScaffoldState> _listdevolutionsScaffoldKey =
      GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

//Controladores para los inputs del filtro
  late TextEditingController idOrderController;
  late TextEditingController dateController;
  late TextEditingController phoneNumberController;

  //Variables del filtro de busqueda
  String? dropdownValue;
  String phoneNumber = "";
  String idOrder = "";
  String endDate = "";
  String startDate = "";
  String status = "";

  List<Map<String, dynamic>> filterIcons = [];

  @override
  void initState() {
    super.initState();

    idOrderController = TextEditingController();
    dateController = TextEditingController();
    phoneNumberController = TextEditingController();

    final userProvider = context.read<UserProvider>();

    if (userProvider.verificationPrivileges('download_devolutions_report')) {
      filterIcons.add({'icon': Icons.download_rounded, 'onPressed': () {}});
    }

    filterIcons.add(
      {
        'icon': Icons.refresh_rounded,
        'onPressed': refreshDevolutions,
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      paginationProvider.resetPagination();

      //peticiones para obtener la lista de devoluciones y la lista de estatus
      await merchantProvider.listStatus('PAYMENT');
      await merchantProvider.listRefunds(
        limit: 5,
        page: 0,
      );

      //el total de elementos para la paginacion sera igual a la cantidad de devoluciones que halla
      if (merchantProvider.refunds != null) {
        paginationProvider.setTotal(merchantProvider.refunds!['count']);
      }
    });
  }

  @override
  void dispose() {
    idOrderController.dispose();
    dateController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  //Reinicio de los valores de los filtros
  void resetFilters() async {
    final paginationProvider = context.read<PaginationProvider>();
    final merchantProvider = context.read<MerchantProvider>();
    setState(() {
      idOrderController.clear();
      dateController.clear();
      phoneNumberController.clear();
      dropdownValue = null;
    });

    phoneNumber = "";
    idOrder = "";
    endDate = "";
    startDate = "";
    status = "";

    await merchantProvider.listRefunds(
      limit: 5,
      page: 0,
      startDate: startDate,
      endDate: endDate,
      idOrder: idOrder,
      tagStatus: status,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.refund!['count']);
  }

  void applyFilters() async {
    final paginationProvider = context.read<PaginationProvider>();

    // Procesar filtros aquí
    status = dropdownValue ?? "";
    idOrder = idOrderController.text;
    phoneNumber = phoneNumberController.text;
    endDate =
        dateController.text != "" ? dateController.text.split(" - ")[1] : "";
    startDate =
        dateController.text != "" ? dateController.text.split(" - ")[0] : "";


    //se hace la peticion con los filtros aplicados
    final merchantProvider = context.read<MerchantProvider>();
    await merchantProvider.listRefunds(
      limit: 5,
      page: 0,
      startDate: startDate,
      endDate: endDate,
      phoneNumber: phoneNumber,
      idOrder: idOrder,
      tagStatus: status,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.refund!['count']);
  }

  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();
    final utilsProvider = context.watch<UtilsProvider>();
    final textStyle = Theme.of(context).textTheme;

    //Componentes que tendra el filtro
    final List<Widget> filters = [
      CustomTextFormField(
          controller: idOrderController,
          hintText: 'Buscar num.orden',
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
      CustomTextFormField(
          controller: phoneNumberController,
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

              if (phoneRegex.hasMatch(value)) {
                return 'El código de área no es válido';
              }
            }

            return null;
          }
          ),
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
          hintText: 'Fechas relevantes',
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
        key: _listdevolutionsScaffoldKey,
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
            preferredSize: Size.fromHeight(80 + MediaQuery.of(context).padding.top),
            child: Screensappbar(
              title: 'Listado de devoluciones',
              screenKey: _listdevolutionsScaffoldKey,
              poproute: merchantScreen,
            )),
        body: Column(
          children: [
            //Si esta cargando o no se tienen valores de los estatus o las devoluciones
            if (merchantProvider.isLoading == true ||
                merchantProvider.status == null ||
                merchantProvider.refunds == null) ...[
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
                merchantProvider.refunds != null) ...[
              //si no hay devoluciones
              if (merchantProvider.refunds!['count'] == 0) ...[
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
                        const Center(child: Text('No hay datos disponibles')),
                      ],
                    ),
                  ),
                )
              ],

              //si hay devoluciones
              if (merchantProvider.refunds!['count'] > 0) ...[
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

                //Tarjetas con informacion de las devoluciones
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: merchantProvider.refunds!['rows'].length,
                      itemBuilder: (context, index) {
                        final refund = merchantProvider.refunds!['rows'][index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          child: TextCard(
                            texts: buildTextsFromDevolutions(refund,
                                statusColors), // Lista con los textos generada
                            onTap: () {
                              merchantProvider.refundInfo = refund;
                              Navigator.pushNamed(
                                context,
                                '/Detalle de devolucion',
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
                    merchantProvider.listRefunds(
                      limit: 5,
                      page: paginationProvider.page,
                      startDate: startDate,
                      endDate: endDate,
                      idOrder: idOrder,
                      tagStatus: status,
                    );
                  },

                  //Funcion al pasar a la pagina anterior
                  onPreviousPressed: () {
                    merchantProvider.listRefunds(
                      limit: 5,
                      page: paginationProvider.page,
                      startDate: startDate,
                      endDate: endDate,
                      idOrder: idOrder,
                      tagStatus: status,
                    );
                  },
                )
              ]
            ]
          ],
        ),
      ),
    );
  }

  void refreshDevolutions() async {
    final paginationProvider = context.read<PaginationProvider>();
    final merchantProvider = context.read<MerchantProvider>();

    await merchantProvider.listRefunds(
      limit: 5,
      page: 0,
      startDate: startDate,
      endDate: endDate,
      idOrder: idOrder,
      tagStatus: status,
    );

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.refund!['count']);
  }

  List<Map<String, dynamic>> buildTextsFromDevolutions(
      Map<String, dynamic> devolution, Map<String, Color> statusColors) {
    List<Map<String, dynamic>> objects = [];

    if (devolution['idOrder'] != null) {
      objects.add({'label': 'Nro. orden: ', 'value': devolution['idOrder']});
    }

    if (devolution['createdDate'] != null) {
      objects.add({
        'label': 'Fecha: ',
        'value':
            DateFormatter.formatDate(DateTime.parse(devolution['createdDate']))
      });
    }

    if (devolution['phoneNumber'] != null) {
      objects.add(
          {'label': 'Nro. teléfono: ', 'value': devolution["phoneNumber"]});
    }

    if (devolution['totalAmount'] != null) {
      objects.add({
        'label': 'Monto total: ',
        'value':
            '${DigitFormatter.getMoneyFormatter(devolution['totalAmount'].toString())} ${devolution['tagCurrency']}'
      });
    }

    if (devolution['namePaymentMethod'] != null) {
      objects.add({
        'label': 'Método de pago: ',
        'value': devolution['namePaymentMethod']
      });
    }

    objects.add({
      'label': 'status',
      'value': devolution['status'],
      'statusColor': statusColors[devolution['status']]
    });

    return objects;
  }
}
