import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/core/storage/secure_store.dart';

/// Provider cấu hình môi trường đang chạy (đọc từ dart-defines).
final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.current);

/// Provider [ApiClient] dùng chung — điểm thay thế khi backend thật về.
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    config: ref.watch(appConfigProvider),
    tokenProvider: () =>
        ref.read(secureStoreProvider).read(SecureStoreKeys.authToken),
  ),
);

/// Callback cấp auth token cho [authTokenInterceptor] — chỗ cắm SEC-S46,
/// đã bật một nửa ở GĐ4-F1: token demo lấy từ [SecureStore]
/// (`SecureStoreKeys.authToken`, ghi bởi `AuthSessionController.login`).
/// Backend thật chỉ đổi GIÁ TRỊ token được ghi vào store, không đổi cơ chế
/// truyền qua đây.
typedef AuthTokenProvider = Future<String?> Function();

/// Lỗi API đã map về tầng domain (SEC-S46): controller hiển thị
/// [userMessage] tiếng Việt, không rò rỉ chi tiết HTTP ra UI.
final class ApiFailure implements Exception {
  const ApiFailure({required this.statusCode, required this.userMessage});

  final int? statusCode;
  final String userMessage;

  @override
  String toString() => 'ApiFailure($statusCode): $userMessage';
}

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

/// Interceptor map [DioException] → lỗi domain (nối idiom ERR-35/ADR-001):
/// timeout/mất kết nối → [OfflineFailure] (controller chuyển máy trạng thái
/// high-risk sang `offline`); HTTP 4xx/5xx → [ApiFailure] với userMessage
/// tiếng Việt. Lỗi domain nằm trong `DioException.error` — repository thật
/// unwrap và ném tiếp cho controller.
Interceptor errorMappingInterceptor() {
  return InterceptorsWrapper(
    onError: (exception, handler) {
      final Object mapped;
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          mapped = const OfflineFailure();
        case DioExceptionType.badResponse:
          final status = exception.response?.statusCode;
          mapped = ApiFailure(
            statusCode: status,
            userMessage: status != null && status >= 500
                ? 'Hệ thống đang gián đoạn. Vui lòng thử lại sau.'
                : 'Yêu cầu không hợp lệ hoặc phiên đã hết hạn. Thử lại sau.',
          );
        case DioExceptionType.badCertificate:
          mapped = const ApiFailure(
            statusCode: null,
            userMessage:
                'Kết nối không an toàn bị chặn. Kiểm tra mạng đang dùng.',
          );
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
          mapped = const ApiFailure(
            statusCode: null,
            userMessage: 'Không thể hoàn tất yêu cầu. Vui lòng thử lại.',
          );
      }
      handler.reject(
        DioException(
          requestOptions: exception.requestOptions,
          response: exception.response,
          type: exception.type,
          message: exception.message,
          error: mapped,
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
  /// SEC-S46 theo thứ tự: auth-token (nếu có [tokenProvider]) → error-mapping.
  /// [pinnedSpkiSha256] không rỗng ⇒ bật certificate pinning fail-closed
  /// (xem [_configurePinning]) — dự kiến chỉ bật ở production khi backend
  /// thật về; danh sách hash KHÔNG hardcode ở đây mà truyền theo môi trường.
  ApiClient({
    required AppConfig config,
    Dio? dio,
    AuthTokenProvider? tokenProvider,
    List<String> pinnedSpkiSha256 = const [],
  }) : dio = dio ?? Dio(_baseOptions(config)) {
    if (dio == null) {
      if (tokenProvider != null) {
        this.dio.interceptors.add(authTokenInterceptor(tokenProvider));
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
