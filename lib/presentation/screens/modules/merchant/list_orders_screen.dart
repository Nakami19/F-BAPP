import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final merchantProvider = context.read<MerchantProvider>();
      print('AYUDAAAAAAAAAAAAAAAAAAAAAAAA');
      print(merchantProvider.isLoading);
      _initializeData();
      print('AYUDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');
      print(merchantProvider.isLoading);
      final utilsProvider = context.read<PaginationProvider>();

      int num = 30;

      // Generar datos de ejemplo
      utilsProvider.newElements = List.generate(
        num,
        (index) => TextCard(
          referencia: index.toString(),
          telefono: index.toString(),
          banco: 'Banesco',
          monto: index.toString(),
        ),
      );

      utilsProvider.setTotal(utilsProvider.elements.length);
    });
  }

  Future<void> _initializeData() async {
    final merchantProvider = context.read<MerchantProvider>();
    await merchantProvider.ListStatus('ORDER');
    await merchantProvider.Listorders(limit: 10, page: 0);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaginationProvider>();
    final elements = provider.getCurrentPage();
    final navProvider = context.watch<NavigationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();

    if (merchantProvider.haveSimpleError) {
      Snackbars.customSnackbar(context,
          message: merchantProvider.errorMessage!);
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
              child: Filter(options: merchantProvider.status!),
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
                    itemCount: elements.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 35),
                          child: elements[index],
                        )),
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
