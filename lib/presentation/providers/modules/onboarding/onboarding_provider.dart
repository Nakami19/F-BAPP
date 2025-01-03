import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/app.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/shared/snackbars.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/services/modules/onboarding/onboarding_services.dart';

class OnboardingProvider extends GeneralProvider{

  //para realizar peticiones
  final onboardingService = OnboardingServices();

  //Listado de verificaciones
  Map<String, dynamic>? verifications;

  Map<String, dynamic>? get getverifications => verifications;

  set setVerificationslist(Map<String, dynamic>? newVerifications) {
    verifications = newVerifications;
    notifyListeners();
  }


  //tipos de plantillas
  List<dynamic>? templateTypes;

  List<dynamic>? get getTemplateTypes => templateTypes;

  set setTemplateTypes(List<dynamic>? newTemplates) {
    templateTypes = newTemplates;
    notifyListeners();
  }

  //estados en las acciones de merchant
  List<dynamic>? verificationStatus;

 List<dynamic>? get getVerificationStatus => verificationStatus;

  set setStatus(List<dynamic>? newStatus) {
    verificationStatus = newStatus;
    notifyListeners();
  }

  //Obtiene el listado de tipos de estado de verificación
  Future<void> listVerificationStatus() async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      final response = await onboardingService.getListVerificationStatus();

      final data = jsonDecode(response.toString());

      setStatus = data['data'];
    } on DioError catch (error) {
      onDioerror(error);

      notifyListeners();

      rethrow;
    } catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());

      Snackbars.customSnackbar(navigatorKey.currentContext!,
          title: "Ocurrió un error inesperado", message: error.toString());
      notifyListeners();
      rethrow;
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  }

  //Obtener el listado de verificaciones
  Future<void> listVerifications({
    int? limit,
    int? page,
    String? search,
    String? startDate,
    String? endDate,
    List<String>? statusesIdsLists,
    String? idVerificationTemplate,
    bool? showFrauds,
    bool? showDuplicates,
  }) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      //se construyen los parametros para la peticion
      final params = <String, dynamic>{};

      if (limit != null) params['limit'] = limit;

      if (page != null) params['page'] = page;

      if (startDate != null && startDate != "") params['startDate'] = startDate;

      if (endDate != null && endDate != "") params['endDate'] = endDate;

      if (statusesIdsLists != null && statusesIdsLists.isNotEmpty) params['statusesIdsList'] = statusesIdsLists;
  
      if (search != null && search != "") params['search'] = search;

      if (idVerificationTemplate != null && idVerificationTemplate != "") params['idVerificationTemplate'] = idVerificationTemplate;
      
      if (showFrauds != null ) params['showFrauds'] = showFrauds;
      
      if (showDuplicates != null ) params['showDuplicates'] = showDuplicates;

      final response = await onboardingService.getVerifications(params);

      final data = jsonDecode(response.toString());

      setVerificationslist = data['data'];
    } on DioError catch (error) {
      onDioerror(error);

      notifyListeners();
    } catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      Snackbars.customSnackbar(navigatorKey.currentContext!,
          title: "Ocurrió un error inesperado", message: error.toString());
      notifyListeners();
    } finally {
      super.setLoadingStatus(false);
      notifyListeners();
    }
  }

  //Obtener tipos de plantillas
  Future<void> verificationTemplates({
    int? limit,
    int? page,
    String? search,
  }) async {
    super.setLoadingStatus(true);
    notifyListeners();

    try {
      //se construyen los parametros para la peticion
      final params = <String, dynamic>{};

      if (limit != null) params['limit'] = limit;

      if (page != null) params['page'] = page;
  
      if (search != null && search != "") params['search'] = search;

      final response = await onboardingService.getVerificationTemplatesV2(params);

      final data = jsonDecode(response.toString());

      setTemplateTypes = data['data'];
    } on DioError catch (error) {
      onDioerror(error);

      notifyListeners();
    } catch (error) {
      super.setSimpleError(true);
      super.setErrorMessage("Ocurrió un error inesperado");
      super.setTrackingCode(error.toString());
      Snackbars.customSnackbar(navigatorKey.currentContext!,
          title: "Ocurrió un error inesperado", message: error.toString());
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

    Snackbars.customSnackbar(navigatorKey.currentContext!,
        title: resp.trackingCode, message: resp.message);
  }

}