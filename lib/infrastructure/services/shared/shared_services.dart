import 'package:dio/dio.dart';
import 'package:f_bapp/common/data/enviroment.dart';
import 'package:f_bapp/config/network/dio_client.dart';

class SharedServices {

  //Tipos de documentos de identidad
  Future<Response> getDocumentType() async {
    try {

    final response = await dio.get(
      '${Enviroment.ccFbusGateway}/v1/list/document_type',
    );
    
    return response;
    } catch (e) {
      rethrow;
    }

  }
}