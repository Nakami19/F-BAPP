import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import '../../config/network/dio_client.dart';



class LoginServices {

//Verifica que el usuario existe
Future<Response> getVerifyMember(String member) async {
  // Verificar que el parámetro 'member' no sea nulo o vacío
  if (member.isEmpty) {
    throw Exception('El parámetro "member" no puede estar vacío');
  }

  // Asegurar que recaptcha esté configurado
  final recaptcha = Enviroment.recaptcha;
if (recaptcha == null || recaptcha.isEmpty) {
  throw Exception('Recaptcha no está configurado');
}

  try {
    final response = await dio.get(
      Enviroment.CC_FBUS_GATEWAY + '/v1/auth/business/verify/member',
      queryParameters: {'member': member},
      options: Options(headers: {
        'recaptcha': recaptcha,
        'Content-Type': 'application/json',
      }),
    );
    return response;
  } catch (e, stackTrace) {
    print('Error al verificar miembro: $e');
  print('Stack trace: $stackTrace');
    rethrow;
  }
}

  //Envía todas las credenciales para loguearse y recibe el token
  Future<Response> postLogin(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        Enviroment.CC_FBUS_GATEWAY +'/v1/auth/business/login',
        data: data,
        options: Options(headers: {
          'recaptcha': Enviroment.recaptcha,
          'Content-Type': 'application/json',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Obtiene el listado de miembros de business
  Future<Response> getMemberTypes({String? member}) async {
    try {
      final response = await dio.get(
        Enviroment.CC_FBUS_GATEWAY +'/v1/profile/business/parent',
        queryParameters: {'member': member},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Llama al API para refrescar sesión
  Future<Response> refreshSession() async {
    try {
      final response = await dio.get(Enviroment.CC_FBUS_GATEWAY +'/v1/profile/token/refresh');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Hace el llamado para enviar token de actualización de contraseña
  Future<Response> sendUpdatePasswordToken() async {
    try {
      final response = await dio.get(Enviroment.CC_FBUS_GATEWAY +'/v1/profile/password/change/token');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Envía el formulario de actualización de contraseña
  Future<Response> putUpdatePassword(Map<String, dynamic> form) async {
    try {
      final response = await dio.put(
        Enviroment.CC_FBUS_GATEWAY +'/v1/profile/password/change',
        data: form,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Solicita token de recuperación de contraseña
  Future<Response> getRecoverPasswordToken(String sender, String recaptcha) async {
    try {
      final response = await dio.get(
        Enviroment.CC_FBUS_GATEWAY +'/v1/auth/business/password/recovery/token',
        queryParameters: {'sender': sender},
        options: Options(headers: {
          'recaptcha': recaptcha,
          'Content-Type': 'application/json',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Envía la recuperación de contraseña
  Future<Response> postRecoverPassword(Map<String, dynamic> form, String recaptcha) async {
    try {
      final response = await dio.post(
        Enviroment.CC_FBUS_GATEWAY +'/v1/auth/business/password/recovery',
        data: form,
        options: Options(headers: {
          'recaptcha': recaptcha,
          'Content-Type': 'application/json',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

}