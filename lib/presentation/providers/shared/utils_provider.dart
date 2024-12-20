import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f_bapp/app.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/shared/snackbars.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:f_bapp/infrastructure/shared/storage_service_impl.dart';

class UtilsProvider extends GeneralProvider {
  final storage = SecureStorageService();
  final normalStorage = StorageService();

  // Usuario
  String? userText;

  String? userName = '';
  String? personName = '';
  String? personLastName = '';



  // int _total = 0; // Total de elementos
  // int _limit = 5; // Límites por página
  // int _page = 0;   // Página actual

  // List<TextCard> elements=[];

  // List<TextCard> get elementsList => elements;

  // // List<String> get elementsList =>
  // //     List.generate(_total, (index) => 'Elemento #${index + 1}');

  // int get total => _total;
  // int get limit => _limit;
  // int get page => _page;

  // void setTotal(int value) {
  //     _total = value;
  //     notifyListeners(); 
    
  // }

  // List<TextCard> getCurrentPage() {
  //   int start = _page * _limit;
  //   int end = start + _limit;
  //   if (end > total) end = total;
  //   return elements.sublist(start, end);
  // }

  // int getNumPages() => (total / limit).ceil();

  // void nextPage() {
  //   if ((_page + 1) * limit < total) {
  //     _page++;
  //     notifyListeners();
  //   }
  // }

  // void previousPage() {
  //   if (_page > 0) {
  //     _page--;
  //     notifyListeners();
  //   }
  // }



    Future<void> getUserinfo() async {
    try {
      super.setLoadingStatus(true);

      final userData = await storage.getValue(
        'userData',
      );


      final decodedData = jsonDecode(userData!);

      userName = decodedData['userName'];
      personName = decodedData['personName'];
      personLastName = decodedData['personLastName'];

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

      notifyListeners();


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
      // super.setErrorMessage(error.message);
      super.setTrackingCode(error.toString());

      Snackbars.customSnackbar(
        navigatorKey.currentContext!,
        title: error.toString(),
        message: ""
      );
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
  }

 

  
}