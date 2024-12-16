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
      await merchantProvider.ListStatus('ORDER');
      await merchantProvider.Listorders(
          limit: 5, page: 0, startDate: '2024/12/16', endDate: '2024/12/16');

      paginationProvider.setTotal(merchantProvider.orders!['count']);
      paginationProvider.setPageData(merchantProvider.orders!['rows']);
    });
  }

  Future<void> _initializeData() async {
    final merchantProvider = context.read<MerchantProvider>();
    await merchantProvider.ListStatus('ORDER');
    await merchantProvider.Listorders(limit: 5, page: 0);
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

    if (merchantProvider.haveSimpleError) {
      Snackbars.customSnackbar(context,
          message: merchantProvider.errorMessage ?? "");
    }

    return Scaffold(
      drawer: DrawerMenu(),
      key: _listordersScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
            title: 'Listado de ordenes',
            screenKey: _listordersScaffoldKey,
            poproute: merchantScreen,
          )),
      body: Column(
        children: [
          if (merchantProvider.isLoading == true) ...[
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Center(
                child: CustomSkeleton(
                  height: 65,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: CustomSkeleton(height: 140),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: CustomSkeleton(height: 140),
            ),
            SizedBox(
              height: 15,
            ),
          ],

          if (merchantProvider.isLoading == false) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              child: Filter(
                id: true,
                phoneNumber: false,
                date: true,
                dropdown: true,
                options: merchantProvider.status!,
                getdata: (filters) async {
                  final merchantProvider = context.read<MerchantProvider>();
                  final paginationProvider = context.read<PaginationProvider>();

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

                  final range = filters['startDate']?.split(' - ') ?? [];
                  final startDate = range.isNotEmpty
                      ? range[0].trim()
                      : DateFormatter.formatDate2(DateTime.now());
                  final endDate = range.length > 1
                      ? range[1].trim()
                      : DateFormatter.formatDate2(DateTime.now());

                  // Llama a la función de obtener datos con los filtros
                  paginationProvider.setFilters(
                    tagStatus: tagStatus,
                    startDate: startDate,
                    endDate: endDate,
                    idOrder: idOrder,
                    idTypeOrder: idTypeOrder,
                  );

                  // Llama a la función de obtener datos con los filtros
                  await paginationProvider.fetchPageData(context);

                  // Actualiza la paginación con los nuevos datos
                  paginationProvider
                      .setTotal(merchantProvider.orders!['count']);
                },
              ),
            ),
            if (merchantProvider.orders?['count'] == 0) ...[
              Expanded(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Center(
                        child: Image.asset(
                          'assets/chinchin/chinchin_empty_state.png', // Ruta relativa en assets
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover, // Ajusta cómo se muestra la imagen
                        ),
                      ),
                      Center(child: Text('No hay datos disponibles')),
                    ],
                  ),
                ),
              )
            ],
            if (merchantProvider.orders?['count'] > 0) ...[
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
                          id: "Id: ${order["idOrder"]}",
                          date: DateFormatter.formatDate(
                              DateTime.parse(order['createdDate'])),
                          status: order["status"],
                          sucursal: order['metadata']["partnerName"] != null
                              ? order['metadata']["partnerName"]
                              : 'N/A',
                          balance: order['balance'].toString(),
                          // monto: order["amount"].toString(),
                          monto: DigitFormatter.getMoneyFormatter(
                              order['amount'].toString()),
                          payType: order['nameTypeOrder'],
                          refundStatus: order['refundStatus'],
                          statusColor: statusColors[order['status']],
                        ),
                      );
                    }),
              ),

              //Paginacion
              Pagination(scrollController: _scrollController)
            ]
          ]
          // if (!merchantProvider.isLoading)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          //     child: Filter(options: merchantProvider.status??[]),
          //   ),
          // if (merchantProvider.orders?['count'] == 0) ...[
          //   Expanded(
          //     child: SingleChildScrollView(
          //       physics: NeverScrollableScrollPhysics(),
          //       child: Column(
          //         children: [
          //           SizedBox(
          //             height: MediaQuery.of(context).size.height * 0.1,
          //           ),
          //           Center(
          //             child: Image.asset(
          //               'assets/chinchin/chinchin_empty_state.png', // Ruta relativa en assets
          //               width: 200,
          //               height: 200,
          //               fit: BoxFit.cover, // Ajusta cómo se muestra la imagen
          //             ),
          //           ),
          //           Center(child: Text('No hay datos disponibles')),
          //         ],
          //       ),
          //     ),
          //   )
          // ],
          // if (merchantProvider.orders?['count'] > 0) ...[
          //   Expanded(
          //     child: ListView.builder(
          //         controller: _scrollController,
          //         itemCount: elements.length,
          //         itemBuilder: (context, index) => Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 15, horizontal: 35),
          //               child: elements[index],
          //             )),
          //   ),

          //   //Paginacion
          //   Pagination(scrollController: _scrollController)
          // ]
        ],
      ),
      bottomNavigationBar: Customnavbar(
          selectedIndex: 2,
          onDestinationSelected: (index) {
            navProvider.updateIndex(index);
          }),
    );
  }
}
