import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/data/offline_failure.dart';
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

  // SEC-S46: chuỗi interceptor mặc định — error-mapping luôn có; auth-token
  // đứng TRƯỚC error-mapping khi có tokenProvider.
  test('interceptor mặc định: error-mapping có mặt, auth đứng trước', () {
    final bare = ApiClient(config: config());
    expect(bare.dio.interceptors.whereType<InterceptorsWrapper>().length, 1);

    final withAuth = ApiClient(
      config: config(),
      tokenProvider: () async => 'token-thu',
    );
    expect(
      withAuth.dio.interceptors.whereType<InterceptorsWrapper>().length,
      2,
    );
  });

  test(
    'authTokenInterceptor gắn Bearer khi có token, bỏ qua khi null',
    () async {
      Future<RequestOptions> run(AuthTokenProvider provider) async {
        // Chạy qua Dio thật với adapter ghi lại request cuối.
        final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
          ..interceptors.add(authTokenInterceptor(provider))
          ..httpClientAdapter = _RecordingAdapter();
        await dio.get<dynamic>('/vi-du');
        return (dio.httpClientAdapter as _RecordingAdapter).lastOptions!;
      }

      final withToken = await run(() async => 'abc');
      expect(withToken.headers['Authorization'], 'Bearer abc');

      final withoutToken = await run(() async => null);
      expect(withoutToken.headers.containsKey('Authorization'), isFalse);
    },
  );

  test('errorMappingInterceptor: timeout/mất mạng → OfflineFailure', () async {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.connectionError,
    ]) {
      final mapped = await _runThroughErrorMapper(type);
      expect(mapped.error, isA<OfflineFailure>(), reason: '$type');
    }
  });

  test(
    'errorMappingInterceptor: badResponse → ApiFailure userMessage vi',
    () async {
      final server = await _runThroughErrorMapper(
        DioExceptionType.badResponse,
        statusCode: 503,
      );
      final serverFailure = server.error as ApiFailure;
      expect(serverFailure.statusCode, 503);
      expect(serverFailure.userMessage, contains('gián đoạn'));

      final client = await _runThroughErrorMapper(
        DioExceptionType.badResponse,
        statusCode: 401,
      );
      final clientFailure = client.error as ApiFailure;
      expect(clientFailure.statusCode, 401);
      expect(clientFailure.userMessage, contains('phiên'));
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

/// Chạy một DioException nhân tạo qua errorMappingInterceptor và trả về
/// exception sau khi map (error chứa lỗi domain).
Future<DioException> _runThroughErrorMapper(
  DioExceptionType type, {
  int? statusCode,
}) async {
  final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
    ..interceptors.add(errorMappingInterceptor())
    ..httpClientAdapter = _ThrowingAdapter(type, statusCode: statusCode);
  try {
    await dio.get<dynamic>('/vi-du');
    fail('phải ném DioException');
  } on DioException catch (exception) {
    return exception;
  }
}

final class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}

final class _ThrowingAdapter implements HttpClientAdapter {
  _ThrowingAdapter(this.type, {this.statusCode});

  final DioExceptionType type;
  final int? statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (type == DioExceptionType.badResponse && statusCode != null) {
      return ResponseBody.fromString('{}', statusCode!);
    }
    throw DioException(requestOptions: options, type: type);
  }

  @override
  void close({bool force = false}) {}
}
