import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    int retryCount = requestOptions.extra['retryCount'] ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      retryCount++;
      requestOptions.extra['retryCount'] = retryCount;

      final delay = baseDelay * retryCount;

      await Future.delayed(delay);

      try {
        final response = await Dio().fetch(requestOptions);
        return handler.resolve(response);
      } catch (_) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type != DioExceptionType.cancel &&
        (err.response?.statusCode == null || err.response!.statusCode! >= 500);
  }
}