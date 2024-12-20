import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';
import 'package:f_bapp/presentation/providers/modules/merchant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PaginationProvider extends GeneralProvider {
  int _total = 0; // Total de elementos
  int _limit = 5; // Límites por página
  int _page = 0;  // Página actual


  int get total => _total;
  int get limit => _limit;
  int get page => _page;


  void setTotal(int value) {
    _total = value;
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

  void resetPagination() {
    _page = 0;
    notifyListeners();
  }

}


