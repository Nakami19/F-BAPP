import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/config/network/dio_client.dart';

class MerchantServices {
  Future<Response> getListStatus (String tag_status) async {
    try {
      final response = await dio.get(
        '${Enviroment.CC_FBUS_GATEWAY}/v1/list/status',
        queryParameters: {'tagTypeStatus': tag_status,},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getOrders(Map<String, dynamic> params) async {
    try {

      // Realizar la solicitud HTTP
      final response = await dio.get(
        '${Enviroment.CC_FBUS_GATEWAY}/v1/list/orders',
        queryParameters: params, 
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }


}