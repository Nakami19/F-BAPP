import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/config/network/dio_client.dart';

class MerchantServices {

  //Api obtener estatus
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

  //Api obtener todas las ordenes
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

  //Api obtener tipos de pagos
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

  //Api obtener listado de pagos
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

  //Api obtener listado de bancos
   Future<Response> getBanksList(Map<String, dynamic> params) async {
    try {

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/list/bank/',
      queryParameters: params
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }


  Future<Response> getRefunds(Map<String, dynamic> params) async {
    try {

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/list/refunds',
      queryParameters: params
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }


Future<Response> postRevertOrder(Map<String, dynamic> params) async {
    try {

    final response = await dio.post(
      '${Enviroment.ccFbusGateway}/v1/operation/merchant_refund_order',
      data: params
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }



}
