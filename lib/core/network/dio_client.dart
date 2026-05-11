import 'package:dio/dio.dart';
import 'retry_interceptor.dart';

class DioClient {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  DioClient() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['x-api-key'] = 'reqres_7e8674e348854226a8b41811f09958ab';
        handler.next(options);
      },
    ));

    dio.interceptors.add(RetryInterceptor(
      maxRetries: 3,
      baseDelay: const Duration(milliseconds: 500),
    ));
  }
}