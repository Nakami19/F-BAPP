import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/cards/text_card.dart';

class PaginationProvider extends GeneralProvider {
  int _total = 0; // Total de elementos
  int _limit = 5; // Límites por página
  int _page = 0;   // Página actual

  List<TextCard> elements=[];

  List<TextCard> filteredelements=[];

  List<TextCard> get elementsList => elements;

  // List<String> get elementsList =>
  //     List.generate(_total, (index) => 'Elemento #${index + 1}');

  int get total => filteredelements.length;
  int get limit => _limit;
  int get page => _page;

  void setTotal(int value) {
      _total = value;
      notifyListeners(); 
    
  }

  set newElements(List<TextCard> newElements) {
    elements = newElements;
    filteredelements = List.from(newElements); // Copia inicial sin filtros
    _total = filteredelements.length;
    notifyListeners();
  }

  // List<TextCard> getCurrentPage() {
  //   int start = _page * _limit;
  //   int end = start + _limit;
  //   if (end > total) end = total;
  //   return elements.sublist(start, end);
  // }

  List<TextCard> getCurrentPage() {
  int start = _page * _limit;
  int end = start + _limit;
  if (end > filteredelements.length) end = filteredelements.length;
  return filteredelements.sublist(start, end);
}

  int getNumPages() => (total / limit).ceil();

  void nextPage() {
    if ((_page + 1) * limit < total) {
      _page++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_page > 0) {
      _page--;
      notifyListeners();
    }
  }



}