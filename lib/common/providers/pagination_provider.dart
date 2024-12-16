import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/text_card.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class PaginationProvider extends GeneralProvider {
//   int _total = 0; // Total de elementos
//   int _limit = 5; // Límites por página
//   int _page = 0;   // Página actual

//   List<TextCard> elements=[];

//   List<TextCard> filteredelements=[];

//   List<TextCard> get elementsList => elements;

//   // List<String> get elementsList =>
//   //     List.generate(_total, (index) => 'Elemento #${index + 1}');

//   int get total => filteredelements.length;
//   int get limit => _limit;
//   int get page => _page;

//   void setTotal(int value) {
//       _total = value;
//       notifyListeners(); 
    
//   }

//   set newElements(List<TextCard> newElements) {
//     elements = newElements;
//     filteredelements = List.from(newElements); // Copia inicial sin filtros
//     _total = filteredelements.length;
//     notifyListeners();
//   }

//   // List<TextCard> getCurrentPage() {
//   //   int start = _page * _limit;
//   //   int end = start + _limit;
//   //   if (end > total) end = total;
//   //   return elements.sublist(start, end);
//   // }

//   List<TextCard> getCurrentPage() {
//   int start = _page * _limit;
//   int end = start + _limit;
//   if (end > filteredelements.length) end = filteredelements.length;
//   return filteredelements.sublist(start, end);
// }

//   int getNumPages() {
//     return (_total/_limit).ceil();
//   }
  
//   // (total / limit).ceil();

//   void nextPage() {
//     if ((_page + 1) * _limit < _total) {
//       _page++;
//       notifyListeners();
//     }
//   }

//   void previousPage() {
//     if (_page > 0) {
//       _page--;
//       notifyListeners();
//     }
//   }



// }

class PaginationProvider extends GeneralProvider {
  int _total = 0; // Total de elementos
  int _limit = 5; // Límites por página
  int _page = 0;  // Página actual

  List<dynamic> _currentPageData = []; // Almacena los datos de la página actual

  int get total => _total;
  int get limit => _limit;
  int get page => _page;
  List<dynamic> get currentPageData => _currentPageData;


  // Filtros
  String? _tagStatus;
  String? _startDate;
  String? _endDate;
  String? _idOrder;
  String? _idTypeOrder;

    String? get tagStatus => _tagStatus;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get idOrder => _idOrder;
  String? get idTypeOrder => _idTypeOrder;


    void setFilters({
    String? tagStatus,
    String? startDate,
    String? endDate,
    String? idOrder,
    String? idTypeOrder,
  }) {
    _tagStatus = tagStatus;
    _startDate = startDate;
    _endDate = endDate;
    _idOrder = idOrder;
    _idTypeOrder = idTypeOrder;
    notifyListeners();
  }

  void setTotal(int value) {
    _total = value;
    notifyListeners();
  }

  void setPageData(List<dynamic> data) {
    _currentPageData = data;
    notifyListeners();
  }

  int getNumPages() {
    return (_total / _limit).ceil();
  }

  Future<void> nextPage(BuildContext context) async {
    if (_page + 1 < getNumPages()) {
      _page++;
      await fetchPageData(context);
    }
  }

  Future<void> previousPage(BuildContext context) async {
    if (_page > 0) {
      _page--;
      await fetchPageData(context);
    }
  }

    Future<void> fetchPageData(BuildContext context) async {
    final merchantProvider = context.read<MerchantProvider>();
    final data = await merchantProvider.Listorders(
      limit: _limit,
      page: _page,
      tagStatus: _tagStatus,
      startDate: _startDate,
      endDate: _endDate,
      idOrder: _idOrder,
      idTypeOrder: _idTypeOrder,
    );
    setPageData(merchantProvider.orders!['rows']);
  }

  void resetPagination() {
    _page = 0;
    _currentPageData = [];
    notifyListeners();
  }

 void updateFilters(Map<String, dynamic> filters) {
  _idOrder = filters['idOrder'];
  _idTypeOrder = filters['idTypeOrder'];
  _tagStatus = filters['tagStatus'];
  _startDate = filters['startDate'];
  _endDate = filters['endDate'];
  notifyListeners();
}

Map<String, dynamic> getFilters() {
  return {
    'idOrder': _idOrder,
    'idTypeOrder': _idTypeOrder,
    'tagStatus': _tagStatus,
    'startDate': _startDate,
    'endDate': _endDate,
  };
}
}