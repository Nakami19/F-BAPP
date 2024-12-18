import 'package:f_bapp/common/assets/theme/app_theme.dart';
import 'package:f_bapp/common/data/date_formatter.dart';
import 'package:f_bapp/common/data/digit_formatter.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/inputs/filter.dart';
import 'package:f_bapp/common/widgets/others/custom_skeleton.dart';
import 'package:f_bapp/common/widgets/others/pagination.dart';
import 'package:f_bapp/common/widgets/others/snackbars.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/services/modules/merchant_services.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      final paginationProvider = context.read<PaginationProvider>();
      paginationProvider.resetPagination();
      paginationProvider.clearFilters();
      final response1 = await merchantProvider.ListStatus('ORDER');
      final response2 = await merchantProvider.Listorders(
          limit: 5,
          page: 0,
          startDate: DateFormatter.formatDate2(DateTime.now()).toString(),
          endDate: DateFormatter.formatDate2(DateTime.now()).toString());

      if (merchantProvider.orders != null) {
        paginationProvider.setTotal(merchantProvider.orders!['count']);
        paginationProvider.setPageData(merchantProvider.orders!['rows']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginationProvider = context.watch<PaginationProvider>();
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();

    final Map<String, Color> statusColors = {
      "ACTIVO": Color(0xff02a8f5),
      "PAGADA": primaryColor,
      "PAGADA CON SOBRANTE": Colors.green,
      "PAGADA CON FALTANTE": Colors.orange,
      "EXPIRADA": Color(0xff595959),
      "REVERSADA": Color.fromARGB(219, 246, 195, 26),
      "RECHAZADO": Color(0xffff0000),
    };

    return WillPopScope(
      onWillPop: () async {
        paginationProvider.clearFilters();
        merchantProvider.disposeValues();
        return true;
      },
      child: Scaffold(
        drawer: DrawerMenu(),
        key: _listordersScaffoldKey,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: Screensappbar(
              title: 'Listado de ordenes',
              screenKey: _listordersScaffoldKey,
              poproute: merchantScreen,
              onBack: () {
                paginationProvider.clearFilters();
                merchantProvider.disposeValues();
              },
            )),
        body: Column(
          children: [
            if (merchantProvider.isLoading == true) ...[
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Filter(
                  id: true,
                  phoneNumber: false,
                  date: true,
                  dropdown: true,
                  options: merchantProvider.status!,
                  getdata: (filters) async {
                    final merchantProvider = context.read<MerchantProvider>();
                    final paginationProvider =
                        context.read<PaginationProvider>();

                    // Reinicia la paginación antes de buscar
                    paginationProvider.resetPagination();

                    // Extrae los filtros
                    final idOrder = filters['idOrder'];
                    final idTypeOrder = filters['idTypeOrder'];
                    final tagStatus = filters['tagStatus'];

                    // final startDate = (filters['startDate']?.isNotEmpty ?? false)
                    //     ? filters['startDate']
                    //     : DateFormatter.formatDate2(DateTime.now());

                    // final endDate = (filters['endDate']?.isNotEmpty ?? false)
                    //     ? filters['endDate']
                    //     : DateFormatter.formatDate2(DateTime.now());

                    final range = filters['startDate']?.split('-') ?? [];
                    final startDate = range.isNotEmpty
                        ? range[0].toString().trim()
                        : DateFormatter.formatDate2(DateTime.now()).toString();
                    final endDate = range.length > 1
                        ? range[1].toString().trim()
                        : DateFormatter.formatDate2(DateTime.now()).toString();

                    print('HEEEEELLLPPP');
                    print(startDate);
                    print(endDate);

                    // Llama a la función de obtener datos con los filtros
                    paginationProvider.setFilters(
                      tagStatus: tagStatus,
                      startDate: startDate,
                      endDate: endDate,
                      idOrder: idOrder,
                    );

                    // Llama a la función de obtener datos con los filtros
                    // await paginationProvider.fetchPageData(context);

                    // Actualiza la paginación con los nuevos datos
                    paginationProvider
                        .setTotal(merchantProvider.orders!['count']);
                  },
                ),
              ),

              if (merchantProvider.orders?['count'] == 0 ||
                  merchantProvider.haveSimpleError == true) ...[
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
              if (merchantProvider.orders?['count'] > 0 && merchantProvider.haveSimpleError==false) ...[
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: paginationProvider.currentPageData.length,
                      itemBuilder: (context, index) {
                        final order = paginationProvider.currentPageData[index];
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
                const Pagination()
              ]
            ]
          ],
        ),
        bottomNavigationBar: Customnavbar(
            selectedIndex: 2,
            onDestinationSelected: (index) {
              navProvider.updateIndex(index);
            }),
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
