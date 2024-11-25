import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../app.dart';
import '../../common/widgets/others/snackbars.dart';
import '../../infrastructure/services/secure_storage_service.dart';
import '../../presentation/providers/app_providers.dart';
import '../../presentation/providers/shared/session_provider.dart';
import '../router/routes.dart';






class HttpInterceptor extends Interceptor {
  bool isNoInternetPopupShown = false;

  final CacheOptions cacheOptions;
  final DioCacheInterceptor cacheInterceptor;
  final List<String> cachedServices = [
    '/v1/auth/business/verify/member',
    '/v1/auth/business/login',
    '/v1/profile/business/parent',
    '/v1/profile/token/refresh',
    '/v1/profile/password/change/token',
    '/v1/profile/password/change',
    '/v1/auth/business/password/recovery/token',
    '/v1/auth/business/password/recovery'
  ];

  HttpInterceptor({
    required this.cacheOptions,
    required this.cacheInterceptor,
  });

  /// ✔ ANTES DE LA PETICIÓN
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final context =
        navigatorKey.currentContext ?? navigatorKey.currentState!.context;
    final sessionProvider = context.read<SessionProvider>();

    final shouldCache = cachedServices.contains(options.path);
    final storage = SecureStorageService();
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none &&
        !isNoInternetPopupShown) {
      sessionProvider.cancelTimer();
      sessionProvider.showNoInternetPopup();
      isNoInternetPopupShown = true;
    }

    final token = await storage.getValue('token');

    // Si tengo token
    options.headers.addAll({'Authorization': 'Bearer $token'});

    final key = CacheOptions.defaultCacheKeyBuilder(options);

    if (shouldCache) {
      final cache = await cacheOptions.store?.get(key);
      if (cache != null) {
        // Devolver la respuesta almacenada en caché
        return handler.resolve(cache.toResponse(options, fromNetwork: false));
      }
    }

    super.onRequest(options, handler);
  }

  /// ✔ AL OBTENER RESPUESTA
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final context =
        navigatorKey.currentContext ?? navigatorKey.currentState!.context;
    final sessionProvider = context.read<SessionProvider>();
    final storage = SecureStorageService();

    //Si viene token en la respuesta
    if (response.data['token'] != null) {
      final token = response.data['token'];
      await storage.setKeyValue('token', token);
      sessionProvider.resetSessionTimer();
    }
    if (response.statusCode == HttpStatus.ok) {
      isNoInternetPopupShown = false; // Restablece la variable
    }
    // Lo de mantenimiento, ya esta listo solo hay que descomentar algo en first login screen
    if (response.data['maintenance'] != null) {
      final maintenance = response.data['maintenance'];
      if (maintenance) {
        sessionProvider.setMaintenanceMode(true);
      } else {
        sessionProvider.setMaintenanceMode(false);
      }
    }

    // Si no viene token en la respuesta
    if (response.data['token'] == null &&
        response.statusCode != HttpStatus.ok) {
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(firstLoginScreen, (route) => false);

      storage
        ..deleteValue(
          'userData',
        )
        ..deleteValue(
          'timeExpiration',
        );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbars.customSnackbar(
          navigatorKey.currentContext!,
          title: 'Ha ocurrido un error',
          message: 'Ingrese nuevamente por favor',
        );

        AppProviders.disposeAllProviders(
          navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        );
      });

      return;
    }

    // cacheInterceptor.onResponse(response, handler);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final storage = SecureStorageService();
    final sessionProvider =
        navigatorKey.currentContext!.read<SessionProvider>();

    // Redirigir si llega un 401 en HTTP
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      sessionProvider.cancelTimer();
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(firstLoginScreen, (route) => false);

      storage
        ..deleteValue(
          'userData',
        )
        ..deleteValue(
          'timeExpiration',
        );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbars.customSnackbar(
          navigatorKey.currentContext!,
          title: 'Sesión finalizada',
          message: err.response?.data['message'],
        );

        AppProviders.disposeAllProviders(
          navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        );
      });
    }

    return super.onError(err, handler);
  }
}
