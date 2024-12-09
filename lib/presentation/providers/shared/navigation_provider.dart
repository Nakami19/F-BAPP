import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 0; 

  int get selectedIndex => _selectedIndex;

  String _selectedCompany = "";

  String get selectedCompany => _selectedCompany;

  void updateIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }

  void updateCompany (String newCompany) {
    _selectedCompany = newCompany;
    notifyListeners();
  }
}