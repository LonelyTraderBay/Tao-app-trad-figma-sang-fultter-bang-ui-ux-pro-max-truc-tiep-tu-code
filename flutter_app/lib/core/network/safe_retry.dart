import 'package:dio/dio.dart';

/// Extra key trên [RequestOptions] — đếm số lần safe-retry đã thực hiện.
const String kSafeRetryCountExtra = 'vittrade.safe_retry_count';

/// Số lần retry tối đa cho GET idempotent (tổng attempt = 1 + max).
const int kSafeRetryMaxAttempts = 2;

/// GET là method idempotent duy nhất được phép retry tự động.
bool isSafeRetryMethod(String method) => method.toUpperCase() == 'GET';

/// Lỗi tạm thời: timeout kết nối/nhận, mất kết nối, hoặc HTTP 502/503/504.
///
/// Không gồm [DioExceptionType.sendTimeout] — GET hiếm khi dính send; và
/// không gồm 4xx / 500 thường (tránh spam retry trên lỗi nghiệp vụ).
bool isTransientDioFailure(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.receiveTimeout:
      return true;
    case DioExceptionType.badResponse:
      final status = exception.response?.statusCode;
      return status == 502 || status == 503 || status == 504;
    case DioExceptionType.sendTimeout:
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
    case DioExceptionType.transformTimeout:
      return false;
    // Dio thêm case enum mới theo minor version.
    // ignore: unreachable_switch_default
    default:
      return false;
  }
}

/// Interceptor retry GET trên lỗi tạm thời — tối đa [kSafeRetryMaxAttempts].
///
/// Đặt SAU [sessionRefreshInterceptor], TRƯỚC [errorMappingInterceptor].
/// Dùng [InterceptorsWrapper] thường (không Queued) để tránh xếp hàng kép
/// với refresh 401. POST/PUT/PATCH/DELETE không bao giờ retry.
Interceptor safeRetryInterceptor({required Dio dio}) {
  return InterceptorsWrapper(
    onError: (exception, handler) async {
      final options = exception.requestOptions;
      if (!isSafeRetryMethod(options.method) ||
          !isTransientDioFailure(exception)) {
        return handler.next(exception);
      }

      final raw = options.extra[kSafeRetryCountExtra];
      final retryCount = raw is int ? raw : 0;
      if (retryCount >= kSafeRetryMaxAttempts) {
        return handler.next(exception);
      }

      options.extra[kSafeRetryCountExtra] = retryCount + 1;
      try {
        final response = await dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } on DioException catch (error) {
        // Nested fetch đã đi qua safe-retry + error-mapping; reject để
        // không map domain lần hai trên chuỗi interceptor ngoài.
        return handler.reject(error);
      }
    },
  );
}
