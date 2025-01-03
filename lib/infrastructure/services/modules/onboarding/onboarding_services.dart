import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/config/network/dio_client.dart';

class OnboardingServices {

  //Api obtener estatus listado de ordenes/devoluciones/pagos
  Future<Response> getVerifications (Map<String, dynamic> params) async {
    try {
      final response = await dio.post(
        '${Enviroment.ccFbusGateway}/v2/profile/verifications',
        data: params,
        //como se usa post se debe usar data en vez de queryParameters
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getVerificationTemplatesV2 (Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        '${Enviroment.ccFbusGateway}/v2/profile/template/types',
        queryParameters: params,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }


}