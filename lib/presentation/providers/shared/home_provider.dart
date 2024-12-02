import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeProvider extends GeneralProvider {
  // final accountInformationKey = GlobalKey<ScaffoldState>();
  // final drawerKey = GlobalKey<ScaffoldState>();


   Views selectedScreen = Views.Home;
  changeScreen(Views val) {
    selectedScreen = val;
    notifyListeners();
  }

  // Obtener vista para el home
  Widget getView(Views selectedScreen) {
    switch (selectedScreen) {
      case Views.Home:
        return const HomeScreen();
      case Views.Profile:
        return const ProfileScreen();

    }
  }
}