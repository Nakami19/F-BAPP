import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/config/network/dio_client.dart';
import 'package:f_bapp/infrastructure/auth/user.dart';
import 'package:f_bapp/infrastructure/services/login_services.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';

import '../shared/general_provider.dart';

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


   Future<void> verifyUser(String username) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      final response = await loginService.getVerifyMember(username);
      final data = jsonDecode(response.toString());
      final exist = response.statusCode == 200 && data['data'] != null && data['data']['exists'] == true;
      super.setUserExist(exist);
      super.setStatusCode(response.statusCode!);


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
  Future<ApiResponse<User>?> login1(String username, String password) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      
      final response = await loginService.postLogin(username, password);
      final data = jsonDecode(response.toString());
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(data);

      super.setStatusCode(response.statusCode!);
      final resp = ApiResponse<User>.fromJson(
        response.data,
        // No se hace ningún mapeo adicional para el caso de éxito (200)
        (json) => User.fromJson(json),
        (json) => null,
      );
      final userDataJson = jsonEncode(resp.data?.toJson());

      _token = data['token'];
      await storageService.setKeyValue('token', _token!);

      storageService
        .setKeyValue(
          'userData',
          userDataJson,
        );


      super.isActionWithUser(true);

      return resp;
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
      rethrow;
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
