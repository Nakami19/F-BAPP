import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/services/modules/merchant_services.dart';

class MerchantProvider extends GeneralProvider {

  final merchantService = MerchantServices();

  Map<String, dynamic>? orders;

  Map<String, dynamic>? get _orders => orders;

  List<dynamic>? status;

  set setOrders(Map<String, dynamic>? neworders) {
    orders = neworders;
    notifyListeners();
  }

  set setStatus(List<dynamic>? newStatus) {
    status = newStatus;
    notifyListeners();
  }

  //se obtienen los listados de estatus 
  Future <void> ListStatus (String tag_status) async {

    super.setLoadingStatus(true);
    notifyListeners();

    try {

      final response = await merchantService.getListStatus(tag_status);

      final data = jsonDecode(response.toString());

      setStatus = data['data'];
      // return data['data'];
      
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
      
      rethrow;
    }catch (error) {
      print('Unexpected error: $error');
      super.setErrors(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      notifyListeners();
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  } 

  Future <void> Listorders (
    {int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? tagStatus,
    String? idTypeOrder,
    String? idOrder,}
    ) async { 
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      //se construyen los parametros para la peticion
      final params = <String, dynamic>{};

      if (limit != null) params['limit'] = limit;
      if (page != null) params['page'] = page;
      if (startDate != null) params['startDate'] = startDate;
      if (endDate != null) params['endDate'] = endDate;
      if (tagStatus != null) params['tagStatus'] = tagStatus;
      if (idTypeOrder != null) params['idTypeOrder'] = idTypeOrder;
      if (idOrder != null) params['idOrder'] = idOrder;

      final response = await merchantService.getOrders(params);

      final data = jsonDecode(response.toString());

      setOrders = data['data'];

      // return data['data'];
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
      
      rethrow;
    }catch (error) {
      print('Unexpected error: $error');
      super.setErrors(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      notifyListeners();
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }

  }
}