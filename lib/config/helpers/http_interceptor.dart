import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:f_bapp/infrastructure/shared/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../app.dart';
import '../../common/widgets/shared/snackbars.dart';
import '../../presentation/providers/app_providers.dart';
import '../../presentation/providers/shared/session_provider.dart';
import '../router/routes.dart';

class HttpInterceptor extends Interceptor {
  // Variable para controlar si se ha mostrado el popup de "Sin Internet"
  bool isNoInternetPopupShown = false;

  // Opciones de caché y un interceptor para gestionar la caché
  final CacheOptions cacheOptions;
  final DioCacheInterceptor cacheInterceptor;

  // Lista de servicios cuyos resultados pueden ser cacheados
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
    // Obtiene el contexto actual de la navegación
    final context =
        navigatorKey.currentContext ?? navigatorKey.currentState!.context;

    final sessionProvider = context.read<SessionProvider>();

    // Verifica si la petición debe ser cacheada
    final shouldCache = cachedServices.contains(options.path);

    final storage = SecureStorageService();

    //Comprueba el estado de conectividad
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none &&
        !isNoInternetPopupShown) {
      // Si no hay conexión y aún no se mostró el popup, se muestra
      sessionProvider.cancelTimer();
      sessionProvider.showNoInternetPopup();
      isNoInternetPopupShown = true;
    }

    // Obtiene el token almacenado y si se tiene se agrega al header
    final token = await storage.getValue('token');

    options.headers.addAll({'Authorization': 'Bearer $token'});

    // Genera una clave única para la caché de la solicitud
    final key = CacheOptions.defaultCacheKeyBuilder(options);

    if (shouldCache) {
      // Si la solicitud debe ser cacheada, intenta obtener la respuesta de la ca
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

    //Si viene token en la respuesta se guarda y reinica el temporizador de la sesion
    if (response.data['token'] != null) {
      final token = response.data['token'];
      await storage.setKeyValue('token', token);
      sessionProvider.resetSessionTimer();
    }
    if (response.statusCode == HttpStatus.ok) {
      isNoInternetPopupShown =
          false; // Restablece la variable si la operacion es exitosa
    }

    // Comprueba si hay un indicador de mantenimiento en la respuesta
    if (response.data['maintenance'] != null) {
      final maintenance = response.data['maintenance'];
      if (maintenance) {
        sessionProvider.setMaintenanceMode(true);
      } else {
        sessionProvider.setMaintenanceMode(false);
      }
    }

    // // Si no hay token en la respuesta y el estado no es exitoso redirige al usuario a la pantalla de inicio de sesión
    if (response.data['token'] == null &&
        response.statusCode != HttpStatus.ok) {
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(firstLoginScreen, (route) => false);

      // Borra los datos del almacenamiento
      storage
        ..deleteValue(
          'userData',
        )
        ..deleteValue(
          'timeExpiration',
        );

      //Se muestra snackbar con mensaje de error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbars.customSnackbar(
          navigatorKey.currentContext!,
          title: 'Ha ocurrido un error',
          message: 'Ingrese nuevamente por favor',
        );

        //se limpian los providers
        AppProviders.disposeAllProviders(
          navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        );
      });

      return;
    }

    super.onResponse(response, handler);
  }

  /// X AL OCURRIR UN ERROR
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final storage = SecureStorageService();
    final sessionProvider =
        navigatorKey.currentContext!.read<SessionProvider>();

    // Redirigir a la pantalla de inicio si llega un 401 en HTTP
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      sessionProvider.cancelTimer();
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(firstLoginScreen, (route) => false);

      // Borra los datos del almacenamiento
      storage
        ..deleteValue(
          'userData',
        )
        ..deleteValue(
          'timeExpiration',
        );

      // Muestra un snackbar indicando que la sesión ha finalizado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Snackbars.customSnackbar(
          navigatorKey.currentContext!,
          title: 'Sesión finalizada',
          message: err.response?.data['message'],
        );

        //Se limpian los providers
        AppProviders.disposeAllProviders(
          navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        );
      });
    }

    return super.onError(err, handler);
  }
}
