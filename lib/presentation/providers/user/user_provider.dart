import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/class/privileges.dart';
import 'package:f_bapp/infrastructure/services/login_services.dart';
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
    setprivileges = privilegeList;
      // // memberlist=response.data["data"];

      // if (data.containsKey('privileges')) {
      //   final privilegesData = data['privileges'];
      //   if (privilegesData is List) {
      //     privileges = privilegesData
      //         .map((privilege) =>
      //             Privilege.fromJson(privilege as Map<String, dynamic>))
      //         .toList();
      //   } else {
      //     privileges = [];
      //   }

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

  Future<void> getMemberTypeChangeList(String idParentRelation, String member) async {
    print(idParentRelation);
    print("EEEEEEEEEEEEEEEEEEEEEEEEEEE");

    super.setLoadingStatus(true);

     try {
    final response = await loginService.getMemberTypeChange(idPrivileges: idParentRelation);
    final response2 = await loginService.getMemberTypes(member: member);
    final data = jsonDecode(response.toString());
    final data2 = jsonDecode(response2.toString());

    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(data);

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


  //   /**
  //  * Llama al API de cambiar de miembro
  //  * @param idParentRelation
  //  * @returns
  //  */
  // getMemberTypeChange(idPrivileges: string) {
  //   let params = {
  //     idPrivileges
  //   }
  //   return this.http.get(
  //     environment.CC_GATEWAY_URL + '/v1/auth/business/change',{
  //       headers: new HttpHeaders({
  //         'Content-Type': 'application/json',
  //       }),
  //       observe: 'response',
  //       params,
  //     }
  //   )
  // }
}
