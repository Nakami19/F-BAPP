import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/config/data_constants/data_constants.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/config/network/dio_client.dart';
import 'package:f_bapp/presentation/screens/auth/first_login_screen.dart';
import 'package:f_bapp/presentation/screens/home_screen.dart';
import 'package:f_bapp/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeProvider extends GeneralProvider {
  // final accountInformationKey = GlobalKey<ScaffoldState>();
  // final drawerKey = GlobalKey<ScaffoldState>();

  static const int maxSeconds = 20;


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


    Future<void> refreshSession() async {
    try {
      // super.setLoadingStatus(true);
      final req = await dio.get(Enviroment.CC_FBUS_GATEWAY+ '/v1/profile/token/refresh');
      // changeLoadingStatus(false);
      super.setStatusCode(req.statusCode!);

      ApiResponse.fromJson(
        req.data,
        (json) => null,
        (json) => null,
      );
    } on DioError catch (error) {
      final response = error.response;
      final data = response?.data as Map<String, dynamic>;
      super.setStatusCode(response!.statusCode!);

      final resp = ApiResponse.fromJson(
        data,
        (json) => null, // No hay data para el caso de error
        (json) => ApiError(
          message: json['message'],
          value: json['value'],
          trackingCode: json['trackingCode'],
        ),
      );

      super.setErrors(true);
      super.setErrorMessage(resp.message);
      super.setTrackingCode(resp.trackingCode);
    }
    // finally {
    //   super.setLoadingStatus(false);
    // }

    notifyListeners();
  }
}