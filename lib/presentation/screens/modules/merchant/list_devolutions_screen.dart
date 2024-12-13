import 'package:f_bapp/common/data/filterdef.dart';
import 'package:f_bapp/common/providers/pagination_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/common/widgets/inputs/filter.dart';
import 'package:f_bapp/common/widgets/others/pagination.dart';
import 'package:f_bapp/config/router/routes.dart';
import 'package:f_bapp/presentation/providers/shared/navigation_provider.dart';
import 'package:f_bapp/presentation/providers/shared/utils_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/customNavbar.dart';
import 'package:f_bapp/presentation/widgets/shared/drawer_menu.dart';
import 'package:f_bapp/presentation/widgets/shared/screensAppbar.dart';
import 'package:flutter/material.dart';
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

  // Variables de filtro y visibilidad
  bool _isFilterVisible = false;
  String _searchQuery = '';
  String? _selectedCategory;
  final List<String> _categories = ['Banesco', 'Mercantil', 'Provincial'];

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
      key: _listdevolutionsScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Screensappbar(
            title: 'Listado de devoluciones',
            screenKey: _listdevolutionsScaffoldKey,
            poproute: merchantScreen,
          )),
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

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaginationProvider>();
//     final elements = provider.getCurrentPage();
//     final navProvider = context.watch<NavigationProvider>();

//     return Scaffold(
//       drawer: DrawerMenu(),
//       key: _listdevolutionsScaffoldKey,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(110),
//         child: Screensappbar(
//           title: 'Listado de devoluciones',
//           screenKey: _listdevolutionsScaffoldKey,
//           poproute: merchantScreen,
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
//             child:  Filter(
//           filters: [
//             FilterDefinition(
//               key: 'referencia',
//               hint: 'Buscar por referencia',
//               filterLogic: (element, query) => element.referencia
//                   .toLowerCase()
//                   .contains(query.toLowerCase()),
//             ),
//             FilterDefinition(
//               key: 'telefono',
//               hint: 'Buscar por teléfono',
//               filterLogic: (element, query) => element.telefono
//                   .toLowerCase()
//                   .contains(query.toLowerCase()),
//             ),
//             FilterDefinition(
//               key: 'banco',
//               hint: 'Buscar por banco',
//               filterLogic: (element, query) => element.banco
//                   .toLowerCase()
//                   .contains(query.toLowerCase()),
//             ),
//           ],
//           onApplyFilters: (filters) {
//             provider.applyFilters(filters);
//           },
//         ),
//           ),
          
//           // Lista de elementos filtrados
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: elements.length,
//               itemBuilder: (context, index) => Padding(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 15, horizontal: 35),
//                 child: elements[index],
//               ),
//             ),
//           ),

//           // Paginación
//           Pagination(scrollController: _scrollController),
//         ],
//       ),
//       bottomNavigationBar: Customnavbar(
//         selectedIndex: 2,
//         onDestinationSelected: (index) {
//           navProvider.updateIndex(index);
//         },
//       ),
//     );
//   }
}



