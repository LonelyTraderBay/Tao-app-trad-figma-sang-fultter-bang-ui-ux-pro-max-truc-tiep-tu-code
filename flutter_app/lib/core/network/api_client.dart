import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_error_mapper.dart';
import 'package:vit_trade_flutter/core/network/session_refresh.dart';
import 'package:vit_trade_flutter/core/storage/secure_store.dart';

export 'package:vit_trade_flutter/core/network/api_error_mapper.dart'
    show
        ApiFailure,
        apiUserMessageForBusinessCode,
        apiUserMessageForStatus,
        mapBadResponseToApiFailure,
        mapDioExceptionToDomain;
export 'package:vit_trade_flutter/core/network/session_refresh.dart'
    show
        SessionAccessTokenRefresher,
        SessionInvalidatedHandler,
        kAuthRetriedExtra,
        sessionAccessTokenRefresherProvider,
        sessionInvalidatedHandlerProvider,
        sessionRefreshInterceptor;

/// Provider cấu hình môi trường đang chạy (đọc từ dart-defines).
final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.current);

/// Provider [ApiClient] dùng chung — điểm thay thế khi backend thật về.
///
/// Refresh callbacks lấy từ [sessionAccessTokenRefresherProvider] /
/// [sessionInvalidatedHandlerProvider] (app override nối AuthSession).
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    config: ref.watch(appConfigProvider),
    tokenProvider: () =>
        ref.read(secureStoreProvider).read(SecureStoreKeys.authToken),
    refreshAccessToken: ref.watch(sessionAccessTokenRefresherProvider),
    onRefreshFailed: ref.watch(sessionInvalidatedHandlerProvider),
  ),
);

/// Callback cấp auth token cho [authTokenInterceptor] — chỗ cắm SEC-S46,
/// đã bật một nửa ở GĐ4-F1: token demo lấy từ [SecureStore]
/// (`SecureStoreKeys.authToken`, ghi bởi `AuthSessionController.login`).
/// Backend thật chỉ đổi GIÁ TRỊ token được ghi vào store, không đổi cơ chế
/// truyền qua đây.
typedef AuthTokenProvider = Future<String?> Function();

/// Interceptor gắn `Authorization: Bearer <token>` khi [tokenProvider] trả
/// token — không có token thì request đi tiếp không header (đường public).
Interceptor authTokenInterceptor(AuthTokenProvider tokenProvider) {
  return InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  );
}

/// Interceptor map [DioException] → lỗi domain (ERR-35/ADR-001 + P0.3):
/// timeout/mất kết nối → [OfflineFailure]; HTTP/business code → [ApiFailure]
/// tiếng Việt. Lỗi domain nằm trong `DioException.error` — repository thật
/// unwrap và ném tiếp cho controller.
Interceptor errorMappingInterceptor() {
  return InterceptorsWrapper(
    onError: (exception, handler) {
      handler.reject(
        DioException(
          requestOptions: exception.requestOptions,
          response: exception.response,
          type: exception.type,
          message: exception.message,
          error: mapDioExceptionToDomain(exception),
        ),
      );
    },
  );
}

final class ApiClient {
  static const defaultConnectTimeout = Duration(seconds: 10);
  static const defaultSendTimeout = Duration(seconds: 15);
  static const defaultReceiveTimeout = Duration(seconds: 20);

  /// [dio] test-injectable; khi tự dựng Dio sẽ gắn sẵn chuỗi interceptor
  /// SEC-S46 theo thứ tự: auth-token (nếu có) → session-refresh (nếu có) →
  /// error-mapping.
  /// [pinnedSpkiSha256] không rỗng ⇒ bật certificate pinning fail-closed
  /// (xem [_configurePinning]) — dự kiến chỉ bật ở production khi backend
  /// thật về; danh sách hash KHÔNG hardcode ở đây mà truyền theo môi trường.
  ApiClient({
    required AppConfig config,
    Dio? dio,
    AuthTokenProvider? tokenProvider,
    SessionAccessTokenRefresher? refreshAccessToken,
    SessionInvalidatedHandler? onRefreshFailed,
    List<String> pinnedSpkiSha256 = const [],
  }) : dio = dio ?? Dio(_baseOptions(config)) {
    if (dio == null) {
      if (tokenProvider != null) {
        this.dio.interceptors.add(authTokenInterceptor(tokenProvider));
      }
      if (refreshAccessToken != null) {
        this.dio.interceptors.add(
          sessionRefreshInterceptor(
            dio: this.dio,
            refreshAccessToken: refreshAccessToken,
            onRefreshFailed: onRefreshFailed ?? () async {},
          ),
        );
      }
      this.dio.interceptors.add(errorMappingInterceptor());
      if (pinnedSpkiSha256.isNotEmpty) {
        _configurePinning(this.dio, pinnedSpkiSha256);
      }
    }
  }

  final Dio dio;

  static BaseOptions _baseOptions(AppConfig config) {
    return BaseOptions(
      baseUrl: config.apiBaseUrl.toString(),
      connectTimeout: defaultConnectTimeout,
      sendTimeout: defaultSendTimeout,
      receiveTimeout: defaultReceiveTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: const {'Accept': 'application/json'},
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    );
  }

  /// Điểm cắm certificate pinning (SEC-S46) — FAIL-CLOSED: khi bật, mọi cert
  /// không khớp danh sách SPKI SHA-256 bị TỪ CHỐI. `badCertificateCallback`
  /// trả false vô điều kiện (cert không qua được chain hệ thống thì càng
  /// không tin); việc so SPKI của cert HỢP LỆ với danh sách pin thực hiện ở
  /// tầng socket khi tích hợp backend thật (TODO đánh dấu — cần đọc DER cert
  /// qua `HttpClient.connectionFactory`/`SecurityContext`, ngoài phạm vi
  /// khung mock hiện tại).
  /// Callback fail-closed dùng khi pinning bật — public để test chốt hành vi
  /// (không dựng được X509Certificate trong test nên nhận Object?).
  static bool pinningBadCertificateCallback(
    Object? certificate,
    String host,
    int port,
  ) => false;

  static void _configurePinning(Dio dio, List<String> pinnedSpkiSha256) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = pinningBadCertificateCallback;
        return client;
      },
    );
  }
}
