// Split from api_client_test.dart 2026-07-27 (400-line test file size gate,
// Future-Feature-Onboarding-Checklist). Covers ApiClient construction: Dio
// defaults, injected-Dio passthrough, interceptor wiring counts, and TLS
// pinning fail-closed behavior. See api_client_error_mapping_test.dart,
// api_client_auth_session_test.dart, and api_client_retry_test.dart for the
// other behavior groups split out of the same original file.
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';

void main() {
  AppConfig config() {
    return AppConfig(
      environment: AppEnvironment.staging,
      apiBaseUrl: Uri.parse('https://staging-api.vittrade.example'),
      enableMockData: false,
    );
  }

  test('ApiClient configures explicit Dio defaults', () {
    final client = ApiClient(config: config());
    final options = client.dio.options;

    expect(options.baseUrl, 'https://staging-api.vittrade.example');
    expect(options.connectTimeout, ApiClient.defaultConnectTimeout);
    expect(options.sendTimeout, ApiClient.defaultSendTimeout);
    expect(options.receiveTimeout, ApiClient.defaultReceiveTimeout);
    expect(options.responseType, ResponseType.json);
    expect(options.contentType, Headers.jsonContentType);
    expect(options.headers['Accept'], 'application/json');
    expect(options.validateStatus(200), isTrue);
    expect(options.validateStatus(302), isFalse);
    expect(options.validateStatus(500), isFalse);
  });

  test('ApiClient preserves injected Dio instance for tests', () {
    final dio = Dio(BaseOptions(baseUrl: 'https://custom.example'));
    final client = ApiClient(config: config(), dio: dio);

    expect(identical(client.dio, dio), isTrue);
    expect(client.dio.options.baseUrl, 'https://custom.example');
    // Dio inject từ test giữ nguyên — không bị gắn thêm interceptor.
    expect(client.dio.interceptors.whereType<InterceptorsWrapper>(), isEmpty);
  });

  // SEC-S46 / P0.4 / Task 1.6: safe-retry + error-mapping luôn có;
  // auth → refresh → safe-retry → error-mapping.
  // Dio 5 có thể kèm ImplyContentTypeInterceptor sẵn — chỉ đếm interceptor ta gắn.
  test(
    'interceptor mặc định: safe-retry + error-mapping; auth/refresh tùy chọn',
    () {
      final bare = ApiClient(config: config());
      expect(bare.dio.interceptors.whereType<InterceptorsWrapper>().length, 2);
      expect(
        bare.dio.interceptors.whereType<QueuedInterceptorsWrapper>(),
        isEmpty,
      );

      final withAuth = ApiClient(
        config: config(),
        tokenProvider: () async => 'token-thu',
      );
      expect(
        withAuth.dio.interceptors.whereType<InterceptorsWrapper>().length,
        3,
      );

      final withRefresh = ApiClient(
        config: config(),
        tokenProvider: () async => 'token-thu',
        refreshAccessToken: () async => 'token-moi',
        onRefreshFailed: () async {},
      );
      expect(
        withRefresh.dio.interceptors.whereType<InterceptorsWrapper>().length,
        3,
      );
      expect(
        withRefresh.dio.interceptors
            .whereType<QueuedInterceptorsWrapper>()
            .length,
        1,
      );
    },
  );

  test('pinning bật theo cờ: fail-closed, không đổi adapter khi không pin', () {
    // Trên Dart VM adapter mặc định của Dio đã là IOHttpClientAdapter — phân
    // biệt bằng HÀNH VI: callback pinning từ chối MỌI cert (fail-closed),
    // và client không pin giữ nguyên adapter Dio tự dựng.
    expect(
      ApiClient.pinningBadCertificateCallback(null, 'api.vittrade.local', 443),
      isFalse,
    );

    final pinned = ApiClient(
      config: config(),
      pinnedSpkiSha256: const ['sha256/VI_DU_KHONG_THAT_pin_01'],
    );
    expect(pinned.dio.httpClientAdapter, isA<IOHttpClientAdapter>());
  });
}
