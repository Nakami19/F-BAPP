import 'package:flutter/material.dart';

import '../../infrastructure/shared/error_type.dart';

class GeneralProvider extends ChangeNotifier {
  List<Map<String, ErrorType>> errors = [];

  bool existUser = false;
  void setUserExist(bool val) {
    existUser = val;
    notifyListeners();
  }

  // 1. usuario o correo
  // 2. telefono
  // 3. CI/RIF
  int userType = 1;
  void setUserType(int val) {
    userType = val;
    notifyListeners();
  }

  bool actionWithUser = true;
  void isActionWithUser(bool val) {
    actionWithUser = val;
    notifyListeners();
  }

  bool haveErrors = false;
  void setErrors(bool val) {
    haveErrors = val;
    notifyListeners();
  }

  String? errorMessage;
  void setErrorMessage(String val) {
    errorMessage = val;
    notifyListeners();
  }

  // objeto data que viene en los errores de las peticiones
  dynamic errorData;
  void setErrorData(dynamic val) {
    errorData = val;
    notifyListeners();
  }

  bool haveSimpleError = false;
  void setSimpleError(bool val) {
    haveSimpleError = val;
    notifyListeners();
  }

  String? trackingCode;
  void setTrackingCode(String val) {
    trackingCode = val;
    notifyListeners();
  }

  bool _haveInputErrors = false;
  bool get haveInputErrors => _haveInputErrors;
  void setInputErrors(bool val) {
    _haveInputErrors = val;
    notifyListeners();
  }

  int? statusCode;
  void setStatusCode(int val) {
    statusCode = val;
    notifyListeners();
  }

  bool isLoading = false;
  void setLoadingStatus(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void disposeValues() {
    setErrors(false);
    setSimpleError(false);
    setErrorMessage('');
    setTrackingCode('');
    setInputErrors(false);
    setStatusCode(0);
    setLoadingStatus(false);
    setUserExist(false);
  }

  void resetValues() {}
}
