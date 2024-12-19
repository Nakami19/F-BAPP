import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  String _selectedCompany = "";

  final int _showNavBarDelay = 180;

  int get showNavBarDelay => _showNavBarDelay;

  String get selectedCompany => _selectedCompany;

  bool get showNavBar => _showNavBar;

  bool _showNavBar = true;

  void updateIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }

  void updateCompany(String newCompany) {
    _selectedCompany = newCompany;
    notifyListeners();
  }

  void updateShowNavBar(bool show) {
    _showNavBar = show;
    notifyListeners();
  }
}
