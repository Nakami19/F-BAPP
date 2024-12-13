import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/common/widgets/inputs/filter.dart';
import 'package:f_bapp/common/widgets/others/pagination.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/infrastructure/services/modules/merchant_services.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaginationProvider>();
    final elements = provider.getCurrentPage();
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      drawer: DrawerMenu(),
      key: _listordersScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
              title: 'Listado de ordenes', screenKey: _listordersScaffoldKey, poproute: merchantScreen,)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: Filter(),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: elements.length,
              itemBuilder: (context, index) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  child: elements[index],
                )
            ),
          ),

          //Paginacion
          Pagination(scrollController: _scrollController)
  
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