import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/classes/auth/user.dart';
import 'package:f_bapp/infrastructure/services/auth/login_services.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
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

  //Status de la biometria
  void changeBiometricStatus(bool val) {
    enabledBiometric = val;
    notifyListeners();
  }

  //El usuario viene de otra cuenta 
  void changeIsFromAnotherAccount(bool val) {
    isFromAnotherAccount = val;
    notifyListeners();
  }

  //Establece si la contraseña debe mostrarse
  bool isPasswordObscure = true;
  void updatePasswordObscure(bool val) {
    isPasswordObscure = val;
    notifyListeners();
  }

  //Verificar que el usuario existe
   Future<void> verifyUser(String username, {bool verifyExist = false}) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      //Se realiza la peticion y se establece si el usuario existe
      final response = await loginService.getVerifyMember(username);
      final data = jsonDecode(response.toString());
      final exist = response.statusCode == 200 && data['data'] != null && data['data']['exists'] == true;
      super.setStatusCode(response.statusCode!);

      //Si el usuario no existe se establece la existencia del error
      if (exist==false) {
        super.setSimpleError(true);
        // super.setTrackingCode(data['trackingCode']);
        super.setErrorMessage(
          'Este usuario no se encuentra registrado en el sistema.',
        );

      }

      super.setUserExist(exist);
      notifyListeners();


    } on DioError catch (error) {
      //En caso de error en la peticion se establece la existencia del usuario, existencia de error, el tracking code y el mensaje de error
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
      super.setSimpleError(true);
    
      super.setUserExist(false);
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  }

  /// Realiza el login
  Future<Map<String, dynamic>?> loginUser(Map<String, dynamic> userdata, {bool isFromBiometric =false}) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {

      //Se realiza la peticion enviando nombre de usuario y clave
      final response = await loginService.postLogin(userdata);
      final data = jsonDecode(response.toString());

      super.setStatusCode(response.statusCode!);
      final resp = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json),
        (json) => null,
      );

    final userDataJson = jsonEncode(resp.data?.toJson());

    //Se almacena el token y datos del usuario
      _token = data['token'];
      await storageService.setKeyValue('token', _token!);

      storageService
        .setKeyValue(
          'userData',
          userDataJson,
        );

      super.isActionWithUser(true);

      return {
      'resp': response.data,
      'userdata': userdata
      // 'privileges': privileges,
    };
    } on DioError catch (error) {
      //En caso de error en la peticion se limpia el token, existencia de error, el tracking code y el mensaje de error

      _token = null; 
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
      super.setSimpleError(true);
      super.setErrorMessage(resp.message);
      super.setTrackingCode(resp.trackingCode);
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  }

  //Cerrar sesion
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
