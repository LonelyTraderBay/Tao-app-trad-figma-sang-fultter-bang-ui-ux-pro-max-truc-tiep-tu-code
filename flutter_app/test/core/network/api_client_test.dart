import 'dart:convert';

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

  // SEC-S46 / P0.4: error-mapping luôn có; auth → refresh → error-mapping.
  // Dio 5 có thể kèm ImplyContentTypeInterceptor sẵn — chỉ đếm interceptor ta gắn.
  test('interceptor mặc định: error-mapping có mặt, auth/refresh tùy chọn', () {
    final bare = ApiClient(config: config());
    expect(bare.dio.interceptors.whereType<InterceptorsWrapper>().length, 1);
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
      2,
    );

    final withRefresh = ApiClient(
      config: config(),
      tokenProvider: () async => 'token-thu',
      refreshAccessToken: () async => 'token-moi',
      onRefreshFailed: () async {},
    );
    expect(
      withRefresh.dio.interceptors.whereType<InterceptorsWrapper>().length,
      2,
    );
    expect(
      withRefresh.dio.interceptors
          .whereType<QueuedInterceptorsWrapper>()
          .length,
      1,
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
      expect(clientFailure.userMessage, contains('Phiên'));
    },
  );

  group('apiUserMessageForStatus', () {
    test('map đủ status P0.3 sang tiếng Việt', () {
      expect(apiUserMessageForStatus(400), contains('không hợp lệ'));
      expect(apiUserMessageForStatus(401), contains('Phiên'));
      expect(apiUserMessageForStatus(403), contains('quyền'));
      expect(apiUserMessageForStatus(404), contains('không còn tồn tại'));
      expect(apiUserMessageForStatus(409), contains('Trạng thái'));
      expect(apiUserMessageForStatus(422), contains('chưa hợp lệ'));
      expect(apiUserMessageForStatus(429), contains('quá nhanh'));
      expect(apiUserMessageForStatus(500), contains('gián đoạn'));
    });

    test('500 kèm traceId cho support, không lộ message BE', () {
      final message = apiUserMessageForStatus(500, traceId: 'req_123');
      expect(message, contains('gián đoạn'));
      expect(message, contains('req_123'));
      expect(message.toLowerCase(), isNot(contains('internal server')));
    });
  });

  group('mapBadResponseToApiFailure', () {
    test('ưu tiên business code + details, bỏ message tiếng Anh', () {
      final mapped = mapBadResponseToApiFailure(
        statusCode: 422,
        data: {
          'code': 'INSUFFICIENT_BALANCE',
          'message': 'Insufficient balance',
          'traceId': 'req_bal_1',
          'details': {'available': '120.00', 'required': '150.00'},
        },
      );

      expect(mapped, isA<ApiFailure>());
      final failure = mapped as ApiFailure;
      expect(failure.code, 'INSUFFICIENT_BALANCE');
      expect(failure.traceId, 'req_bal_1');
      expect(failure.userMessage, contains('120.00'));
      expect(failure.userMessage, contains('150.00'));
      expect(failure.userMessage, isNot(contains('Insufficient')));
    });

    test('LIMIT_EXCEEDED → copy hạn mức tiếng Việt', () {
      final mapped =
          mapBadResponseToApiFailure(
                statusCode: 422,
                data: {'code': 'LIMIT_EXCEEDED', 'message': 'Limit exceeded'},
              )
              as ApiFailure;
      expect(mapped.userMessage, contains('hạn mức'));
      expect(mapped.userMessage, isNot(contains('Limit exceeded')));
    });

    test('NETWORK_UNAVAILABLE → OfflineFailure', () {
      final mapped = mapBadResponseToApiFailure(
        statusCode: 503,
        data: {'code': 'NETWORK_UNAVAILABLE'},
      );
      expect(mapped, isA<OfflineFailure>());
    });

    test('body JSON string vẫn parse được', () {
      final mapped =
          mapBadResponseToApiFailure(
                statusCode: 409,
                data: jsonEncode({
                  'code': 'LIMIT_EXCEEDED',
                  'trace_id': 'req_snake',
                }),
              )
              as ApiFailure;
      expect(mapped.code, 'LIMIT_EXCEEDED');
      expect(mapped.traceId, 'req_snake');
    });

    test('code lạ fallback HTTP status, không dùng message BE', () {
      final mapped =
          mapBadResponseToApiFailure(
                statusCode: 403,
                data: {
                  'code': 'UNKNOWN_WIDGET',
                  'message': 'Something exploded in English',
                },
              )
              as ApiFailure;
      expect(mapped.code, 'UNKNOWN_WIDGET');
      expect(mapped.userMessage, contains('quyền'));
      expect(mapped.userMessage, isNot(contains('exploded')));
    });
  });

  test('errorMappingInterceptor: body business code đi qua Dio', () async {
    final mapped = await _runThroughErrorMapper(
      DioExceptionType.badResponse,
      statusCode: 422,
      body: {
        'code': 'INSUFFICIENT_BALANCE',
        'message': 'Insufficient balance',
        'details': {'available': '10', 'required': '20'},
      },
    );
    final failure = mapped.error as ApiFailure;
    expect(failure.code, 'INSUFFICIENT_BALANCE');
    expect(failure.userMessage, contains('khả dụng: 10'));
  });

  test('sessionRefreshInterceptor: 401 refresh thành công rồi retry', () async {
    var refreshCalls = 0;
    var failedCalls = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
      ..httpClientAdapter = _SequencedStatusAdapter(const [401, 200]);
    dio.interceptors.add(
      sessionRefreshInterceptor(
        dio: dio,
        refreshAccessToken: () async {
          refreshCalls++;
          return 'token-moi';
        },
        onRefreshFailed: () async {
          failedCalls++;
        },
      ),
    );

    final response = await dio.get<dynamic>('/vi-du');
    expect(response.statusCode, 200);
    expect(refreshCalls, 1);
    expect(failedCalls, 0);
  });

  test('sessionRefreshInterceptor: refresh null → onRefreshFailed', () async {
    var failedCalls = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
      ..httpClientAdapter = _SequencedStatusAdapter(const [401]);
    dio.interceptors.add(
      sessionRefreshInterceptor(
        dio: dio,
        refreshAccessToken: () async => null,
        onRefreshFailed: () async {
          failedCalls++;
        },
      ),
    );

    await expectLater(dio.get<dynamic>('/vi-du'), throwsA(isA<DioException>()));
    expect(failedCalls, 1);
  });

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
  Object? body,
}) async {
  final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
    ..interceptors.add(errorMappingInterceptor())
    ..httpClientAdapter = _ThrowingAdapter(
      type,
      statusCode: statusCode,
      body: body,
    );
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
  _ThrowingAdapter(this.type, {this.statusCode, this.body});

  final DioExceptionType type;
  final int? statusCode;
  final Object? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (type == DioExceptionType.badResponse && statusCode != null) {
      final payload = body == null
          ? '{}'
          : body is String
          ? body as String
          : jsonEncode(body);
      return ResponseBody.fromString(
        payload,
        statusCode!,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    throw DioException(requestOptions: options, type: type);
  }

  @override
  void close({bool force = false}) {}
}

/// Trả lần lượt các status code — dùng cho kịch bản 401 rồi retry 200.
final class _SequencedStatusAdapter implements HttpClientAdapter {
  _SequencedStatusAdapter(this.statusCodes);

  final List<int> statusCodes;
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final status = statusCodes[_index.clamp(0, statusCodes.length - 1)];
    if (_index < statusCodes.length) {
      _index++;
    }
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
