import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/config/network/dio_client.dart';
import 'package:f_bapp/infrastructure/auth/privileges.dart';
import 'package:f_bapp/infrastructure/auth/user.dart';
import 'package:f_bapp/infrastructure/services/login_services.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/presentation/providers/user/privileges_provider.dart';

import '../../../common/providers/general_provider.dart';

class LoginProvider extends GeneralProvider { 
  final storageService = SecureStorageService();
  final loginService = LoginServices();
  String? userLogin;
  String? password;
  String? _token;
  String? get token => _token;
  bool enabledBiometric = false;
  //Variable que dice si vengo desde otra cuenta (cuando tenga biometria activa)
  bool isFromAnotherAccount = false;

  void changeBiometricStatus(bool val) {
    enabledBiometric = val;
    notifyListeners();
  }

  void changeIsFromAnotherAccount(bool val) {
    isFromAnotherAccount = val;
    notifyListeners();
  }

  bool isPasswordObscure = true;
  void updatePasswordObscure(bool val) {
    isPasswordObscure = val;
    notifyListeners();
  }


   Future<void> verifyUser(String username, {bool verifyExist = false}) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      final response = await loginService.getVerifyMember(username);
      final data = jsonDecode(response.toString());
      final exist = response.statusCode == 200 && data['data'] != null && data['data']['exists'] == true;
      super.setStatusCode(response.statusCode!);
      if (exist==false) {
        super.setUserExist(exist);
        super.setSimpleError(true);
        super.setErrorMessage(
          'Este usuario no se encuentra registrado en el sistema.',
        );
        notifyListeners();
        return;
      }

      super.setUserExist(exist);
      
      


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
      super.setTrackingCode(resp.trackingCode);
      super.setUserExist(false);
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  }

  /// Realiza el login
  Future<Map<String, dynamic>?> login1(Map<String, dynamic> userdata, {bool isFromBiometric =false}) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      
      final response = await loginService.postLogin(userdata);
      final data = jsonDecode(response.toString());
      // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      // print(response.data);

      super.setStatusCode(response.statusCode!);
      final resp = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json),
        (json) => null,
      );

    final userDataJson = jsonEncode(resp.data?.toJson());
    final List<Privilege> privileges = (resp.privileges as List<dynamic>)
    .map((privilege) => Privilege.fromJson(privilege as Map<String, dynamic>))
    .toList();

    final privilegesJson = jsonEncode(
  (resp.privileges as List<dynamic>)
      .map((privilege) => Privilege.fromJson(privilege as Map<String, dynamic>).toJson())
      .toList(),
);

    // print("SERAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    // print(resp);

      _token = data['token'];
      await storageService.setKeyValue('token', _token!);
      //       print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      // print(userDataJson);
      // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA PRIVILEGIOS");
      // print(resp.privileges);
      storageService
        .setKeyValue(
          'userData',
          userDataJson,
        );
      


      super.isActionWithUser(true);

      return {
      'resp': resp,
      'privileges': privileges,
    };
    } on DioError catch (error) {
      _token = null; // Limpia el token si ocurre un error
      final response = error.response;
      final data = response?.data as Map<String, dynamic>;
      super.setStatusCode(response!.statusCode!);

      final resp = ApiResponse.fromJson(
        data,
        (json) => data['data'], // No hay data para el caso de error
        (json) => ApiError(
          message: json['message'],
          value: json['value'],
          trackingCode: json['trackingCode'],
        ),
      );

      super.setErrors(true);
      super.setErrorMessage(resp.message);
      super.setTrackingCode(resp.trackingCode);
    } finally {
      super.setLoadingStatus(false);;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    await storageService.deleteValue('token');
    notifyListeners();
  }

  Future<void> checkSession() async {
    _token = await storageService.getValue('token');
    notifyListeners();
  }


}
