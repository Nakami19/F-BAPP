import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/app.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/shared/snackbars.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/classes/modules/privileges.dart';
import 'package:f_bapp/infrastructure/services/auth/login_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends GeneralProvider {
  final loginService = LoginServices();

  //se guardan datos del usuario, sus privilegios, las acciones de un privilegio seleccionado y el listado de miembros
  List<Privilege>? privileges;

  List<Map<String, dynamic>>? memberlist;

  List<Privilege>? get privilege => privileges;

  List<PrivilegesActions> actions = [];

  List<PrivilegesActions> get privilegeActions => actions;

  //se guardan las acciones del privilegio al que se va a acceder
  void setActions(List<PrivilegesActions> newActions) {
    actions = newActions;
    notifyListeners();
  }

  set setprivileges(List<Privilege>? newPrivilege) {
    privileges = newPrivilege;
    notifyListeners();
  }


  // Se obtiene la informacion del usuario de una compañia
  Future<void> getMemberlist(String member) async {
    try {
      final response = await loginService.getMemberTypes(member: member);
      final data = jsonDecode(response.toString());

       memberlist = List<Map<String, dynamic>>.from(data['data']);

    //se establecen los privilegios
    final privilegesData = data['privileges'] as List;
    final privilegeList = privilegesData.map((privilegeJson) => Privilege.fromJson(privilegeJson)).toList();
    setprivileges = privilegeList;


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

    //Se establece que hay un error, el mensaje y el tracking code
      super.setErrorMessage(resp.message);
      super.setSimpleError(true);

      super.setTrackingCode(resp.trackingCode);
      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: resp.trackingCode,
        message: resp.message
      );
      notifyListeners();
    } catch (error) {
      print('Unexpected error: $error');
      super.setErrors(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      notifyListeners();
    }
  }

  //Se obtiene el listado de miembros
  Future<void> getMemberTypeChangeList(String idParentRelation, String member) async {

    super.setLoadingStatus(true);

     try {
    final response = await loginService.getMemberTypeChange(idPrivileges: idParentRelation);
    final response2 = await loginService.getMemberTypes(member: member);
    final data = jsonDecode(response.toString());
    final data2 = jsonDecode(response2.toString());

    // Procesamiento de datos según el formato esperado
    if (data2.containsKey('privileges')) {
      final privilegesData = data2['privileges'] as List;
      final privilegeList = privilegesData.map((privilegeJson) => Privilege.fromJson(privilegeJson)).toList();
      
      // Asignar lista de privilegios
      setprivileges = privilegeList;
    }
    
    notifyListeners();
  } on DioError catch (error) {
    final response = error.response;
    final data = response?.data as Map<String, dynamic>;

    // Manejo de errores personalizado
    final resp = ApiResponse.fromJson(
      data,
      (json) => json['data'],
      (json) => ApiError(
        message: json['message'],
        value: json['value'],
        trackingCode: json['trackingCode'],
      ),
    );

    super.setErrorMessage(resp.message);
    super.setSimpleError(true);
    super.setTrackingCode(resp.trackingCode);

    Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: resp.trackingCode,
        message: resp.message
      );
    notifyListeners();
  } catch (error) {
    print('Unexpected error: $error');
    super.setErrors(true);
    super.setErrorMessage("Ocurrió un error inesperado");
    super.setTrackingCode(error.toString());
    notifyListeners();
  } finally {
    setLoadingStatus(false);
  }

  }

}
