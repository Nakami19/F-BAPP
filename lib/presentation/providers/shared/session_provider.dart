import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:f_bapp/common/widgets/others/dialogs.dart';
import 'package:f_bapp/presentation/providers/shared/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';
import '../../../common/assets/theme/app_theme.dart';
import '../../../common/widgets/others/snackbars.dart';
import '../../../config/router/routes.dart';
import '../../../infrastructure/services/secure_storage_service.dart';
import '../app_providers.dart';

class SessionProvider with ChangeNotifier {
  final storage = SecureStorageService();
  bool _isAuthenticated = false;
  bool _isDialogOpen = false;
  int? _expirationTime;
  Timer? _timer;
  bool _isMaintenanceMode = false;
  bool get isMaintenanceMode => _isMaintenanceMode;

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

                    final homeProvider = context.read<HomeProvider>();
                    await homeProvider.refreshSession().then(
                      (value) {
                        if (homeProvider.statusCode == HttpStatus.ok) {
                          Navigator.pop(context, true);
                        }
                      },
                    );

                    if (homeProvider.statusCode != HttpStatus.ok) {
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
        timer.cancel();
        _timer?.cancel();
        destroySession();
      }
    }});
  }

  void resetSessionTimer() {
    if (!_isAuthenticated) {
      return;
    }

    if (_timer != null) {
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

  @override
  void dispose() {
    _timer?.cancel();
    _isAuthenticated = false;
    super.dispose();
  }
}
