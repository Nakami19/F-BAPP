import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:f_bapp/flavors.dart';
import '../../common/data/enviroment.dart';
import '../helpers/http_interceptor.dart';


// Configuración de opciones de caché para el manejo de solicitudes HTTP.
final cacheOptions = CacheOptions(
  store: MemCacheStore(), // Almacena los datos en memoria (RAM) para el caché.
  hitCacheOnErrorExcept: [400, 401, 403], // Usar caché si ocurre un error en la solicitud, excepto para estos códigos de error.
  maxStale: const Duration(minutes: 15), // Tiempo máximo de vida para los datos almacenados en caché.
  priority: CachePriority.low, // Prioridad baja para las operaciones de caché.
  keyBuilder: CacheOptions.defaultCacheKeyBuilder, // generar claves de caché basadas en la solicitud.
  allowPostMethod: false, // No permite almacenar en caché las solicitudes HTTP POST.
);

// Interceptor de caché configurado con las opciones definidas anteriormente.
final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

// Configuración de Dio
final dio = Dio(
  BaseOptions(
    baseUrl: FlavorConfig.flavorValues.baseUrl, // Define la URL base según el entorno de la aplicación
    connectTimeout: const Duration(minutes: 2), // Tiempo máximo para intentar establecer una conexión.
    sendTimeout: const Duration(minutes: 2), // Tiempo máximo para enviar datos a través de la conexión.
    receiveTimeout: const Duration(minutes: 2), // Tiempo máximo para recibir datos de la respuesta.
    headers: {
      'recaptcha': Enviroment.recaptcha, // Agrega un encabezado personalizado para las solicitudes, relacionado con reCAPTCHA.
    },
  ),
)
// Agrega un interceptor para registrar solicitudes y respuestas con `TalkerDioLogger`.
..interceptors.add(
  TalkerDioLogger(
    settings: const TalkerDioLoggerSettings(
      printRequestHeaders: true, // Imprime los encabezados de la solicitud en la consola.
      printResponseHeaders: true, // Imprime los encabezados de la respuesta en la consola.
      printResponseMessage: true, // Imprime el mensaje de la respuesta en la consola.
      printRequestData: true, // Imprime los datos enviados en la solicitud.
      printResponseData: true, // Imprime los datos recibidos en la respuesta.
    ),
  ),
)
// Agrega el interceptor de caché previamente configurado.
..interceptors.add(cacheInterceptor)
// Agrega un interceptor personalizado para manejar la lógica adicional (posiblemente relacionada con la caché o validación de tokens).
..interceptors.add(
  HttpInterceptor(
    cacheOptions: cacheOptions, // Pasa las opciones de caché al interceptor personalizado.
    cacheInterceptor: cacheInterceptor, // Pasa el interceptor de caché para reutilizarlo en la lógica personalizada.
  ),
);
