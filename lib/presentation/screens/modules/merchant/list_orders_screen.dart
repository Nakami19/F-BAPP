import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/inputs/custom_dropdown.dart';
import 'package:f_bapp/common/widgets/inputs/custom_text_form_field.dart';
import 'package:f_bapp/common/widgets/inputs/date_input.dart';
import 'package:f_bapp/common/widgets/inputs/filter_container.dart';
import 'package:f_bapp/common/widgets/shared/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/shared/pagination.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screens_appbar.dart';
import 'package:f_bapp/presentation/widgets/shared/text_card.dart';
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

  //Colores para los estados (Activo, Pagado...)
  final Map<String, Color> statusColors = {
    "ACTIVO": Color(0xff02a8f5),
    "PAGADA": primaryColor,
    "PAGADA CON SOBRANTE": Colors.green,
    "PAGADA CON FALTANTE": Colors.orange,
    "EXPIRADA": Color(0xff595959),
    "REVERSADA": Color.fromARGB(219, 246, 195, 26),
    "RECHAZADO": Color(0xffff0000),
  };

//Controladores para los inputs del filtro
  late TextEditingController idController;
  late TextEditingController dateController;

  //Variables del filtro de busqueda
  String? dropdownValue;
  String search ="";
  String id="";
  String endDate = DateFormatter.formatDate2(DateTime.now()).toString();
  String startDate = DateFormatter.formatDate2(DateTime.now()).toString();

  @override
  void initState() {
    super.initState();

    idController = TextEditingController();
    dateController = TextEditingController(
        text: '$startDate - $endDate');
            // '${DateFormatter.formatDate2(DateTime.now()).toString()} - ${DateFormatter.formatDate2(DateTime.now()).toString()}');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();

      //se reinicia la paginacion
      paginationProvider.resetPagination();

      //peticiones para obtener la lista de ordenes y la lista de estatus
      await merchantProvider.ListStatus('ORDER');
       await merchantProvider.Listorders(
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
  void resetFilters() {
    setState(() {
      idController.clear();
      dateController.text =
          '${DateFormatter.formatDate2(DateTime.now()).toString()} - ${DateFormatter.formatDate2(DateTime.now()).toString()}';
      dropdownValue = null;
    });
  }

  void applyFilters() async {
    final paginationProvider = context.read<PaginationProvider>();

    // Procesar filtros aquí
    search = dropdownValue??"";
    id = idController.text;
    endDate = dateController.text.split(" - ")[1];
    startDate = dateController.text.split(" - ")[0];

    //se hace la peticion con los filtros aplicados
    final merchantProvider = context.read<MerchantProvider>();
   await  merchantProvider.Listorders(
        page: 0,
        limit: 5,
        startDate: startDate,
        endDate: endDate,
        idOrder: id,
        tagStatus: search);

    paginationProvider.resetPagination();
    paginationProvider.setTotal(merchantProvider.orders!['count']);
    
  }


  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();
    final textStyle = Theme.of(context).textTheme;

    final List<Widget> filters = [
      CustomTextFormField(
        controller: idController,
        hintText: 'Buscar id',
        hintStyle:
            textStyle.bodySmall!.copyWith(fontSize: 17, color: Colors.grey),
        enabled: true,
        // validator: widget.validatorId
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
          itemLabelMapper: (option) => option['nameStatus']!,
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
            if (merchantProvider.isLoading == true ||
                merchantProvider.status == null ||
                merchantProvider.orders == null) ...[
              SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Center(
                  child: CustomSkeleton(
                    height: 65,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: CustomSkeleton(height: 140),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: CustomSkeleton(height: 140),
              ),
              SizedBox(
                height: 15,
              ),
            ],
            if (merchantProvider.isLoading == false) ...[
              if (merchantProvider.orders?['count'] == 0 ||
                  merchantProvider.haveSimpleError == true) ...[
                    Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Filter(
                    inputs: filters,
                    onReset: resetFilters,
                    onApply: applyFilters,
                  ),
                ),
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
              if (merchantProvider.orders?['count'] > 0 &&
                  merchantProvider.haveSimpleError == false) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Filter(
                    inputs: filters,
                    onReset: resetFilters,
                    onApply: applyFilters,
                  ),
                ),

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
                              print('Orden seleccionada: ${order['idOrder']}');
                            },
                          ),
                        );
                      }),
                ),

                //Paginacion
                Pagination(
                  onNextPressed: () {
                    merchantProvider.Listorders(
                        page: paginationProvider.page,
                        limit: 5,
                        startDate: startDate,
                        endDate: endDate,
                        idOrder: id,
                        tagStatus: search);
                  },
                  onPreviousPressed: () {
                    merchantProvider.Listorders(
                        page: paginationProvider.page,
                        limit: 5,
                        startDate: startDate,
                        endDate: endDate,
                        idOrder: id,
                        tagStatus: search);
                  },
                )
              ]
            ]
          ],
        ),
        // bottomNavigationBar: Customnavbar(
        //     selectedIndex: 2,
        //     onDestinationSelected: (index) {
        //       navProvider.updateIndex(index);
        //     }),
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
