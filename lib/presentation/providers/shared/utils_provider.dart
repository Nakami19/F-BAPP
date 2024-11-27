import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/config/network/dio_client.dart';
import 'package:f_bapp/infrastructure/services/secure_storage_service.dart';
import 'package:f_bapp/infrastructure/services/storage_service_impl.dart';

class UtilsProvider extends GeneralProvider {
  final storage = SecureStorageService();
  final normalStorage = StorageService();

  // Usuario
  String? userText;

  // Tipo de moneda
  String? currencyText;

  // Seleccionar cuenta bancaria
  String? bankAccountText;

  // Monto

  // Descripción
  String? descriptionText;

  // Monto
  String? mountText;

    Future<void> getUserPreferences() async {
    // late ApiResponse<ProfileAccountInfo> resp;
    try {
      super.setLoadingStatus(true);

      final req = await dio.get('/v1/profile/accounts');

      super.setStatusCode(req.statusCode!);

      // resp = ApiResponse<ProfileAccountInfo>.fromJson(
      //   req.data,
      //   (json) => ProfileAccountInfo.fromJson(json),
      //   (json) => null,
      // );

      final userData = await storage.getValue(
        'userData',
      );

      final decodedData = jsonDecode(userData!);


      final userCompleteNameJson = jsonEncode({
        'personName': decodedData['personName'],
        'personLastName': decodedData['personLastName']
      });

      //* Nombre completo del usuario
      var encodedUserData =
          await normalStorage.getValue<String>('userCompleteName');

      //* Veo si la biometría está habilitada
      var enabledBiometricValue =
          await normalStorage.getValue<String>('enabledBiometric');

      final enabledBiometric = enabledBiometricValue == "true" ? true : false;

      //* Solo guardo si no hay un nombre guardado anteriormente
      if (encodedUserData == '' ||
          encodedUserData == null && enabledBiometric == true) {
        // Aqui guardo esta variable en el ls
        normalStorage.setKeyValue<String>(
          'userCompleteName',
          userCompleteNameJson,
        );
      }


      // return resp;
    } on DioError catch (error) {
      final response = error.response;
      final data = error.response?.data as Map<String, dynamic>;
      super.setStatusCode(response!.statusCode!);

      // resp = ApiResponse.fromJson(
      //   data,
      //   (json) => null, // No hay data para el caso de error
      //   (json) => ApiError(
      //     message: json['message'],
      //     value: json['value'],
      //     trackingCode: json['trackingCode'],
      //   ),
      // );


      // Obtengo igualmente los datos del usuario
      final userData = await storage.getValue(
        'userData',
      );

      final decodedData = jsonDecode(userData!);



      super.setErrors(true);
      // super.setErrorMessage(resp.message);
      // super.setTrackingCode(resp.trackingCode);
    } finally {
      super.setLoadingStatus(false);
    }

    notifyListeners();

    // return resp;
  }

   String capitalize(String str) {
    return str
        .split(' ')
        .map((str) => str.isEmpty
            ? ''
            : '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}')
        .join(' ');
  }

  void clearValues() {
    super.disposeValues();
    super.isActionWithUser(true);
    userText = null;
    currencyText = null;
    bankAccountText = null;
    mountText = null;
    descriptionText = null;
  }

  @override
  void resetValues(
      {bool? cleanCurrencyAndBanks = true, bool? clearUseFundsOptions = true}) {

    if (cleanCurrencyAndBanks!) {
      currencyText = null;
    }

    mountText = null;
    descriptionText = null;

  }

  void returnValues({bool? cleanCurrencyAndBanks = false}) {
    mountText = null;

  }

  
}