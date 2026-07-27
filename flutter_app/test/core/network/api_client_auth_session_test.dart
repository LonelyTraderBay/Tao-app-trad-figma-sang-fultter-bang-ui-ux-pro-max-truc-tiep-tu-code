// Split from api_client_test.dart 2026-07-27 (400-line test file size gate,
// Future-Feature-Onboarding-Checklist). Covers authTokenInterceptor and
// sessionRefreshInterceptor. See api_client_config_test.dart,
// api_client_error_mapping_test.dart, and api_client_retry_test.dart for the
// other behavior groups split out of the same original file.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/core/network/session_refresh.dart';

void main() {
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
