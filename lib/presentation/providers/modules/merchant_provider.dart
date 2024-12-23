import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/app.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/shared/snackbars.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/services/modules/merchant_services.dart';

class MerchantProvider extends GeneralProvider {
  //para realizar las peticiones
  final merchantService = MerchantServices();

  Map<String, dynamic>? payments;

  Map<String, dynamic>? get getpayment => payments;

  set setPaymentslist(Map<String, dynamic>? newPayment) {
    payments = newPayment;
    notifyListeners();
  }

  //informacion de la orden para el detalle en caso de no tener respuesta de api
  Map<String, dynamic>? orderInfo;

  Map<String, dynamic>? get infoOrder => orderInfo;

  set infoOrder(Map<String, dynamic>? newinfo) {
    orderInfo=newinfo;
    notifyListeners();
  }

   //ordenes del listado de ordenes
  Map<String, dynamic>? orders;

  Map<String, dynamic>? get order => orders;

  set setOrders(Map<String, dynamic>? neworders) {
    orders = neworders;
    notifyListeners();
  }

//estados en las acciones de merchant
  List<dynamic>? status;

  set setStatus(List<dynamic>? newStatus) {
    status = newStatus;
    notifyListeners();
  }

//informacion del usuario 
  Map<String, dynamic>? userData;

  Map<String, dynamic>? get dataUser => userData;

  set setuserData(Map<String, dynamic>? newdata) {
    userData = newdata;
    notifyListeners();
  }

  //se obtienen los listados de estatus 
  Future <void> listStatus (String tagstatus) async {

    super.setLoadingStatus(true);
    notifyListeners();

    try {

      final response = await merchantService.getListStatus(tagstatus);

      final data = jsonDecode(response.toString());

      setStatus = data['data'];
      
    } on DioError catch (error) {

     onDioerror(error);

      
      notifyListeners();
      
      rethrow;
    }catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());

      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: "Ocurrió un error inesperado",
        message: error.toString()
      );
      notifyListeners();
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  } 

//Obtener el listado de ordenes
  Future <void> listorders (
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
      if (startDate != null && startDate !="") params['startDate'] = startDate;
      if (endDate != null && endDate !="") params['endDate'] = endDate;
      if (tagStatus != null && tagStatus !="") params['tagStatus'] = tagStatus;
      if (idTypeOrder != null && idTypeOrder !="") params['idTypeOrder'] = idTypeOrder;
      if (idOrder != null && idOrder !="") params['idOrder'] = idOrder;

      final response = await merchantService.getOrders(params);

      final data = jsonDecode(response.toString());

      setOrders = data['data'];

    } on DioError catch (error) {
      onDioerror(error);
      
      notifyListeners();
      
    }catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: "Ocurrió un error inesperado",
        message: error.toString()
      );
      notifyListeners();
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }

  }


  //Obtener detalle de orden
  Future <Map<String, dynamic>> orderDetail (String idOrder) async { 
    super.setLoadingStatus(true);
    notifyListeners();

    try {

      final response = await merchantService.getOrderDetail(idOrder);

      final data = jsonDecode(response.toString());

      return data['data'];

    } on DioError catch (error) {
      onDioerror(error);
      
      notifyListeners();

      rethrow;
      
    }catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: "Ocurrió un error inesperado",
        message: error.toString()
      );
      notifyListeners();
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }

  }

  //obtener tipos de pagos
  Future <List<dynamic>> typePayment () async { 
    super.setLoadingStatus(true);
    notifyListeners();

    try {

      final response = await merchantService.getTypePayments();

      final data = jsonDecode(response.toString());

      return data['data'];

    } on DioError catch (error) {
      onDioerror(error);
      
      notifyListeners();

      rethrow;
      
    }catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: "Ocurrió un error inesperado",
        message: error.toString()
      );
      notifyListeners();
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }

  }

  //Obtener las devoluciones de un usuario
  Future<void> getTransactionsList({
  int? limit,
  int? page,
  String? startDate,
  String? endDate,
  bool? refunds,
  String? idOrder,
  String? idPaymentType,
  String? tagStatus,
}) async {
  super.setLoadingStatus(true);
  notifyListeners();

  try {
    // Construir los parámetros para la petición
    final params = <String, dynamic>{};

    if (limit != null) params['limit'] = limit;
    if (page != null) params['page'] = page;
    if (startDate != null && startDate.isNotEmpty) params['startDate'] = startDate;
    if (endDate != null && endDate.isNotEmpty) params['endDate'] = endDate;
    if (refunds != null) params['refunds'] = refunds;
    if (idOrder != null && idOrder.isNotEmpty) params['idOrder'] = idOrder;
    if (idPaymentType != null && idPaymentType.isNotEmpty) params['idPaymentType'] = idPaymentType;
    if (tagStatus != null && tagStatus.isNotEmpty) params['tagStatus'] = tagStatus;

    // Realizar la petición
    final response = await merchantService.getTransactions(params);

    final data = jsonDecode(response.toString());
    
    setPaymentslist = data['data'];

    } on DioError catch (error) {
      onDioerror(error);
      
      notifyListeners();
      
    }catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: "Ocurrió un error inesperado",
        message: error.toString()
      );
      notifyListeners();
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }

  }

  void onDioerror(error) {
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

      super.setSimpleError(true);
      super.setErrorMessage(resp.message);
      

      super.setTrackingCode(resp.trackingCode);

      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: resp.trackingCode,
        message: resp.message
      );
  }
}