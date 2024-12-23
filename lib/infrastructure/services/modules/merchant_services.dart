import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/config/network/dio_client.dart';

class MerchantServices {


  Future<Response> getListStatus (String tagstatus) async {
    try {
      final response = await dio.get(
        '${Enviroment.ccFbusGateway}/v1/list/status',
        queryParameters: {'tagTypeStatus': tagstatus,},
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
        '${Enviroment.ccFbusGateway}/v1/list/orders',
        queryParameters: params, 
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Api detalle de orden
 
  Future<Response> getOrderDetail(String idOrder) async {
    try {
      Map<String, dynamic> params = {
      'idOrder':idOrder,
    };

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/list/detail/order',
      queryParameters: params,
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }

  
  Future<Response> getTypePayments() async {
    try {

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/list/types_payment',
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }

   Future<Response> getTransactions(Map<String, dynamic> params) async {
    try {

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/list/payments',
      queryParameters: params
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }

}
