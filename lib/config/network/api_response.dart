import 'api_error.dart';


class ApiResponse<T> {
  final String apiVersion;
  final String trackingCode;
  T? data;
  List<ApiError>? errors;
  final String message;
  final bool maintenance;
  final int date;
  final dynamic langVersion;
  final dynamic token;
  final List<dynamic> privileges;
  final dynamic appVersion;

  ApiResponse({
    required this.apiVersion,
    required this.trackingCode,
    this.data,
    this.errors,
    required this.message,
    required this.maintenance,
    required this.date,
    this.langVersion,
    this.token,
    required this.privileges,
    this.appVersion,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    Function? dataFromJson,
    Function? errorDataFromJson,
  ) {
    T? data;
    List<ApiError>? errorList;

    if (dataFromJson != null && json.containsKey('data')) {
      final jsonData = json['data'];

      if (T == List) {
        if (jsonData is List) {
          data = jsonData.map((item) => dataFromJson(item)).toList() as T?;
        }
      } else {
        if (jsonData != null) {
          data = dataFromJson(jsonData) as T?;
        } else {
          data = null;
        }
      }
    } else if (errorDataFromJson != null && json.containsKey('data')) {
      if (json['data'] is List) {
        final errorDataList = json['data'] as List<dynamic>;
        errorList = errorDataList
            .map((errorData) => errorDataFromJson(errorData))
            .cast<ApiError>()
            .toList();
      } else {
        errorList = [errorDataFromJson(json['data'])];
      }
    }

    return ApiResponse<T>(
      apiVersion: json['apiVersion'],
      trackingCode: json['trackingCode'],
      data: data,
      message: json['message'],
      maintenance: json['maintenance'],
      date: json['date'],
      langVersion: json['langVersion'],
      token: json['token'],
      errors: errorList,
      privileges: List<dynamic>.from(json['privileges'].map((x) => x)),
      appVersion: json['appVersion'],
    );
  }

  @override
  String toString() {
    return '''
    ApiResponse(
      apiVersion: $apiVersion,
      trackingCode $trackingCode,
      data: $data,
      message: $message,
      maintenance: $maintenance,
      date: $date,
      langVersion: $langVersion,
      token: $token,
      privileges: $privileges,
      appVersion: $apiVersion,
    )
    ''';
  }
}
