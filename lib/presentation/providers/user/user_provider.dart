import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/auth/privileges.dart';
import 'package:f_bapp/infrastructure/services/login_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends GeneralProvider {
  final loginService = LoginServices();

  //se guardan datos del usuario, sus privilegios y el listado de miembros
  List<Privilege>? privileges;

  List<Map<String, dynamic>>? memberlist;

  List<Privilege>? get _privilege => privileges;

  set Setprivileges(List<Privilege>? newPrivilege) {
    privileges = newPrivilege;
    notifyListeners();
  }

  //determina si debe mostrarse el mensaje de error
  bool _errorShown = false;
  void clearError() {
    haveErrors = false;
    errorMessage = null;
    trackingCode = null;
    notifyListeners();
  }

  bool get shouldShowError {
    if (haveErrors && !_errorShown) {
      _errorShown = true; // Marca el error como mostrado
      return true;
    }
    return false;
  }

//se obtiene el listado de miembros
  Future<void> getMemberlist(String member) async {
    try {
      final response = await loginService.getMemberTypes(member: member);
      final data = jsonDecode(response.toString());

       memberlist = List<Map<String, dynamic>>.from(data['data']);

    final privilegesData = data['privileges'] as List;
    final privilegeList = privilegesData.map((privilegeJson) => Privilege.fromJson(privilegeJson)).toList();
    Setprivileges = privilegeList;
      // // memberlist=response.data["data"];

      // print(data["privileges"]);
      // if (data.containsKey('privileges')) {
      //   print("JAJAJAJAJAJAJJAJAJAJ");
      //   final privilegesData = data['privileges'];
      //   if (privilegesData is List) {
      //     privileges = privilegesData
      //         .map((privilege) =>
      //             Privilege.fromJson(privilege as Map<String, dynamic>))
      //         .toList();
      //   } else {
      //     privileges = [];
      //   }
      //   print("JJOJOJOJOJOJOJOJ");
      //   print(privileges);
      // } else {
      //   privileges = [];
      // }

      // if (data.containsKey('data')) {
      //   memberlist = (data['data'] as List<dynamic>?)
      //           ?.map((item) => item as Map<String, dynamic>)
      //           .toList() ??
      //       [];
      // } else {
      //   memberlist = [];
      // }


      notifyListeners();
    } on DioError catch (error) {
      final response = error.response;
      final data = response?.data as Map<String, dynamic>;

      final resp = ApiResponse.fromJson(
        response?.data as Map<String, dynamic>,
        (json) => data['data'], // No hay data para el caso de error
        (json) => ApiError(
          message: json['message'],
          value: json['value'],
          trackingCode: json['trackingCode'],
        ),
      );

      super.setErrorMessage(resp.message);
      super.setSimpleError(true);

      super.setTrackingCode(resp.trackingCode);
      notifyListeners();
    } catch (error) {
      print('Unexpected error: $error');
      super.setErrors(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      notifyListeners();
    }
  }
}
