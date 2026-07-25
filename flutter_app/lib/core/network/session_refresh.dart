import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Làm mới access token khi API trả 401 — chỗ cắm P0.4 (chưa cần BE ký).
///
/// Trả access token mới, hoặc `null` khi không refresh được (caller xóa phiên).
typedef SessionAccessTokenRefresher = Future<String?> Function();

/// Gọi khi refresh thất bại / 401 sau retry — thường map tới logout an toàn.
typedef SessionInvalidatedHandler = Future<void> Function();

/// Default `null` = không gắn refresh interceptor. App layer override để nối
/// [AuthSessionController.tryRefreshAccessToken] / [AuthSessionController.logout]
/// mà `core/` không import `app/`.
final sessionAccessTokenRefresherProvider =
    Provider<SessionAccessTokenRefresher?>((ref) => null);

final sessionInvalidatedHandlerProvider = Provider<SessionInvalidatedHandler?>(
  (ref) => null,
);

/// Extra key trên [RequestOptions] — chặn vòng lặp refresh vô hạn.
const String kAuthRetriedExtra = 'vittrade.auth_retried';

/// Interceptor 401 → refresh → retry một lần; fail → [onRefreshFailed].
///
/// Đặt SAU [authTokenInterceptor], TRƯỚC [errorMappingInterceptor].
/// Dùng [QueuedInterceptorsWrapper] để nhiều request 401 đồng thời chỉ
/// refresh một lần tuần tự.
Interceptor sessionRefreshInterceptor({
  required Dio dio,
  required SessionAccessTokenRefresher refreshAccessToken,
  required SessionInvalidatedHandler onRefreshFailed,
}) {
  return QueuedInterceptorsWrapper(
    onError: (exception, handler) async {
      final status = exception.response?.statusCode;
      if (status != 401) {
        return handler.next(exception);
      }

      final options = exception.requestOptions;
      if (options.extra[kAuthRetriedExtra] == true) {
        await onRefreshFailed();
        return handler.next(exception);
      }

      try {
        final newToken = await refreshAccessToken();
        if (newToken == null || newToken.isEmpty) {
          await onRefreshFailed();
          return handler.next(exception);
        }

        options.headers['Authorization'] = 'Bearer $newToken';
        options.extra[kAuthRetriedExtra] = true;
        final response = await dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } catch (_) {
        await onRefreshFailed();
        return handler.next(exception);
      }
    },
  );
}
