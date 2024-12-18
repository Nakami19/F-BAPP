import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/presentation/widgets/shared/text_card.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
  String? _phoneNumber;

    String? get tagStatus => _tagStatus;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get idOrder => _idOrder;
  String? get phoneNumber => _phoneNumber;


    void setFilters({
    String? tagStatus,
    String? startDate,
    String? endDate,
    String? idOrder,
    String? phoneNumber,
  }) {
    _tagStatus = tagStatus;
    _startDate = startDate;
    _endDate = endDate;
    _idOrder = idOrder;
    _phoneNumber = phoneNumber;
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
      // await fetchPageData(context);
    }
  }

  Future<void> previousPage(BuildContext context) async {
    if (_page > 0) {
      _page--;
      // await fetchPageData(context);
    }
  }

  //   Future<void> fetchPageData(BuildContext context) async {
  //   final merchantProvider = context.read<MerchantProvider>();
  //   final data = await merchantProvider.Listorders(
  //     limit: _limit,
  //     page: _page,
  //     tagStatus: _tagStatus,
  //     startDate: _startDate,
  //     endDate: _endDate,
  //     idOrder: _idOrder,
  //   );
  //   setPageData(merchantProvider.orders!['rows']);
  // }



  void resetPagination() {
    _page = 0;
    _currentPageData = [];
    notifyListeners();
  }

  void clearFilters() {
  _tagStatus = null;
  _startDate = null;
  _endDate = null;
  _idOrder = null;
  _phoneNumber = null;
  notifyListeners();
}

 void updateFilters(Map<String, dynamic> filters) {
  _idOrder = filters['idOrder'];
  _phoneNumber = filters['phoneNumber'];
  _tagStatus = filters['tagStatus'];
  _startDate = filters['startDate'];
  _endDate = filters['endDate'];
  notifyListeners();
}

Map<String, dynamic> getFilters() {
  return {
    'idOrder': _idOrder,
    'phoneNumber': _phoneNumber,
    'tagStatus': _tagStatus,
    'startDate': _startDate,
    'endDate': _endDate,
  };
}
}


