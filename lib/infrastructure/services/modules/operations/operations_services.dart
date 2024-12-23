import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/config/network/dio_client.dart';

class OperationsServices {
  // /**
  //  * Servicio para traer las cuentas bancariar del usuario
  //  */
  // getChinchinAccounts() {
  //   return this.http.get(this.url + '/v1/profile/accounts');
  // }

  //Api para traer las cuentas bancariar del usuario
   Future<Response> getChinchinAccounts() async {
    try {

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/profile/accounts',
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }
  
}