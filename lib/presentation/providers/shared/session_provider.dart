import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:f_bapp/common/assets/theme/app_colors.dart';
import 'package:f_bapp/common/providers/general_provider.dart';
import 'package:f_bapp/common/widgets/shared/dialogs.dart';
import 'package:f_bapp/config/network/api_error.dart';
import 'package:f_bapp/config/network/api_response.dart';
import 'package:f_bapp/infrastructure/services/auth/login_services.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:flutter/material.dart';
import '../../../app.dart';
import '../../../common/widgets/shared/snackbars.dart';
import '../../../config/router/routes.dart';
import '../app_providers.dart';
import 'navigation_provider.dart';

//no se movieron a general provider ya que en otros providers no son necesarios estos metodos

class SessionProvider extends GeneralProvider {
  final storage = SecureStorageService();
  final loginService = LoginServices();
  bool _isAuthenticated = false;
  bool _isDialogOpen = false;
  int? _expirationTime;
  Timer? _timer;
  bool _isTimerPaused = false; 
  bool _isMaintenanceMode = false;
  bool get isMaintenanceMode => _isMaintenanceMode;
  static const int maxSeconds = 20;

  void setMaintenanceMode(bool value) {
    _isMaintenanceMode = value;
    notifyListeners(); 
  }

  void startSessionTimer(int time) {
    bool isActionSuccessClicked = false;

    if (!_isAuthenticated) {
      return;
    }

    _expirationTime = time;
    final context =
        navigatorKey.currentContext ?? navigatorKey.currentState!.context;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // print(time);
      if (_isTimerPaused) return; // No realizar acciones si está pausado
      time -= 1000;

      if (_timer != null) {
        if (time <= 30000 && !_isDialogOpen) {
          if (time <= 10000 && !_isDialogOpen) {
          _isDialogOpen = true;
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Dialogs.customDialog(
                context,
                title: 'Refrescar sesión',
                content: const Text('¿Deseas extender el tiempo de tu sesión?'),
                cancelButtonText: 'CERRAR',
                closeAction: () {
                  timer.cancel();
                  destroySession();
                },
                actionSuccess: () async {
                  if (!isActionSuccessClicked) {
                    isActionSuccessClicked = true;

                   await refreshSession().then(
                      (value) {
                        if (statusCode == HttpStatus.ok) {
                          Navigator.pop(context, true);
                        }
                      },
                    );

                    if (statusCode != HttpStatus.ok) {
                      return;
                    }

                    _isDialogOpen = false;
                    _timer?.cancel();
                    timer.cancel();
                    resetSessionTimer();
                  }
                },
              ),
            ),
          );
        }
      }

      if (time <= 0) {
        _isTimerPaused = false;
        timer.cancel();
        _timer?.cancel();
        destroySession();
      }
    }});
  }

  void pauseTimer() {
    if (_timer != null && !_isTimerPaused) {
      _isTimerPaused = true;
      _timer?.cancel();
    }
  }

  void resetSessionTimer() {
    if (!_isAuthenticated) {
      _isTimerPaused = false;
      return;
    }

    if (_timer != null) {
      _isTimerPaused = false;
      _timer?.cancel();
      startSessionTimer(_expirationTime!);
    }
  }

  void showNoInternetPopup() async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AlertDialog(
                  title: const Text(
                    'No se ha podido procesar su solicitud',
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    'Verifica tu conexión a internet',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () async {
                          final connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            showNoInternetPopup();
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

  void destroySession({bool? haveModalAction = true}) {
    _timer?.cancel();
    _timer = null;
    _isDialogOpen = false;
    _isAuthenticated = false;


    storage
      ..deleteValue(
        'userData',
      )
      ..deleteValue(
        'timeExpiration',
      );

    if (haveModalAction != null && haveModalAction) {
      Navigator.pop(
        navigatorKey.currentContext ?? navigatorKey.currentState!.context,
      );

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        firstLoginScreen,
        (route) => false,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbars.customSnackbar(
          navigatorKey.currentContext!,
          title: '¡Vuelva pronto!',
          message: 'Su sesión ha expirado exitosamente.',
        );

        AppProviders.disposeAllProviders(
          navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        );
      });
    }
  }

  void authenticateUser() {
    _isAuthenticated = true;
  }

  void cancelTimer({bool? haveModalAction = true}) {
    _timer?.cancel();
    _isDialogOpen = false;
    _isAuthenticated = false;

    storage
      ..deleteValue(
        'userData',
      )
      ..deleteValue(
        'timeExpiration',
      );

    if (haveModalAction != null && haveModalAction) {
      Navigator.pop(
        navigatorKey.currentContext ?? navigatorKey.currentState!.context,
      );

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        firstLoginScreen,
        (route) => false,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppProviders.disposeAllProviders(
          navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        );
      });
    }
  }

  Future<void> refreshSession() async {
    pauseTimer();
    try {
      super.setLoadingStatus(true);
      final req = await loginService.refreshSession();
      super.setStatusCode(req.statusCode!);

      ApiResponse.fromJson(
        req.data,
        (json) => null,
        (json) => null,
      );
    } on DioError catch (error) {
      final response = error.response;
      final data = response?.data as Map<String, dynamic>;
      super.setStatusCode(response!.statusCode!);

      final resp = ApiResponse.fromJson(
        data,
        (json) => null, // No hay data para el caso de error
        (json) => ApiError(
          message: json['message'],
          value: json['value'],
          trackingCode: json['trackingCode'],
        ),
      );

      super.setErrors(true);
      super.setErrorMessage(resp.message);
      super.setTrackingCode(resp.trackingCode);
    }
    finally {
      super.setLoadingStatus(false);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _isAuthenticated = false;
    super.dispose();
  }
}
