import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:f_bapp/flavors.dart';
import '../../common/data/constants.dart';
import '../../common/data/enviroment.dart';
import '../helpers/http_interceptor.dart';


// Global options
final cacheOptions = CacheOptions(
  store: MemCacheStore(),
  hitCacheOnErrorExcept: [400, 401, 403],
  maxStale: const Duration(minutes: 15),
  priority: CachePriority.low,
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  allowPostMethod: false,
);

final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

final dio = Dio(
  BaseOptions(
    // baseUrl: Environment.getUrl(Connection.developer),
    baseUrl: FlavorConfig.flavorValues.baseUrl,
    connectTimeout: const Duration(minutes: 2),
    sendTimeout: const Duration(minutes: 2),
    receiveTimeout: const Duration(minutes: 2),
    headers: {
      'recaptcha': Enviroment.recaptcha,
    },
  ),
)
  ..interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
        printRequestData: true,
        printResponseData: true,
      ),
    ),
  )
  ..interceptors.add(cacheInterceptor)
  ..interceptors.add(
    HttpInterceptor(
      cacheOptions: cacheOptions,
      cacheInterceptor: cacheInterceptor,
    ),
  );