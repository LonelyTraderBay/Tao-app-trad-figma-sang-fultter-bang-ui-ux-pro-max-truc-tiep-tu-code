// Split from api_client_test.dart 2026-07-27 (400-line test file size gate,
// Future-Feature-Onboarding-Checklist). Covers safeRetryInterceptor and
// isTransientDioFailure/isSafeRetryMethod. See api_client_config_test.dart,
// api_client_error_mapping_test.dart, and api_client_auth_session_test.dart
// for the other behavior groups split out of the same original file.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/core/network/api_error_mapper.dart';
import 'package:vit_trade_flutter/core/network/safe_retry.dart';

void main() {
  group('safeRetryInterceptor', () {
    test('GET: connectionTimeout rồi 200 → retry thành công', () async {
      final adapter = _SequencedMixedAdapter([
        const _AdapterStep.fail(DioExceptionType.connectionTimeout),
        const _AdapterStep.status(200),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(safeRetryInterceptor(dio: dio));

      final response = await dio.get<dynamic>('/vi-du');
      expect(response.statusCode, 200);
      expect(adapter.fetchCount, 2);
    });

    test('GET: 503 ×2 rồi 200 → đúng max 2 retries', () async {
      final adapter = _SequencedMixedAdapter([
        const _AdapterStep.status(503),
        const _AdapterStep.status(503),
        const _AdapterStep.status(200),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(safeRetryInterceptor(dio: dio));

      final response = await dio.get<dynamic>('/vi-du');
      expect(response.statusCode, 200);
      expect(adapter.fetchCount, 3);
    });

    test(
      'GET: hết 2 retries vẫn lỗi → map OfflineFailure/ApiFailure',
      () async {
        final adapter = _SequencedMixedAdapter([
          const _AdapterStep.status(503),
          const _AdapterStep.status(503),
          const _AdapterStep.status(503),
        ]);
        final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
          ..httpClientAdapter = adapter;
        dio.interceptors.add(safeRetryInterceptor(dio: dio));
        dio.interceptors.add(errorMappingInterceptor());

        try {
          await dio.get<dynamic>('/vi-du');
          fail('phải ném DioException');
        } on DioException catch (exception) {
          expect(adapter.fetchCount, 3);
          final failure = exception.error as ApiFailure;
          expect(failure.statusCode, 503);
          expect(failure.userMessage, contains('gián đoạn'));
        }
      },
    );

    test('POST: 503 không retry (bảo vệ high-risk mutate)', () async {
      final adapter = _SequencedMixedAdapter([
        const _AdapterStep.status(503),
        const _AdapterStep.status(200),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(safeRetryInterceptor(dio: dio));

      await expectLater(
        dio.post<dynamic>('/withdraw/confirm'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.fetchCount, 1);
    });

    test('PUT/PATCH/DELETE: lỗi tạm thời không retry', () async {
      for (final method in ['PUT', 'PATCH', 'DELETE']) {
        final adapter = _SequencedMixedAdapter([
          const _AdapterStep.fail(DioExceptionType.connectionError),
          const _AdapterStep.status(200),
        ]);
        final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
          ..httpClientAdapter = adapter;
        dio.interceptors.add(safeRetryInterceptor(dio: dio));

        await expectLater(
          dio.request<dynamic>('/resource', options: Options(method: method)),
          throwsA(isA<DioException>()),
        );
        expect(adapter.fetchCount, 1, reason: method);
      }
    });

    test('GET: 400 không retry', () async {
      final adapter = _SequencedMixedAdapter([
        const _AdapterStep.status(400),
        const _AdapterStep.status(200),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://khong-goi.example'))
        ..httpClientAdapter = adapter;
      dio.interceptors.add(safeRetryInterceptor(dio: dio));

      await expectLater(
        dio.get<dynamic>('/vi-du'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.fetchCount, 1);
    });

    test('isTransientDioFailure: chỉ timeout kết nối/nhận + 502/503/504', () {
      RequestOptions opts() => RequestOptions(path: '/x');

      expect(
        isTransientDioFailure(
          DioException(
            requestOptions: opts(),
            type: DioExceptionType.connectionTimeout,
          ),
        ),
        isTrue,
      );
      expect(
        isTransientDioFailure(
          DioException(
            requestOptions: opts(),
            type: DioExceptionType.sendTimeout,
          ),
        ),
        isFalse,
      );
      expect(
        isTransientDioFailure(
          DioException(
            requestOptions: opts(),
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: opts(), statusCode: 500),
          ),
        ),
        isFalse,
      );
      expect(
        isTransientDioFailure(
          DioException(
            requestOptions: opts(),
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: opts(), statusCode: 502),
          ),
        ),
        isTrue,
      );
      expect(isSafeRetryMethod('get'), isTrue);
      expect(isSafeRetryMethod('POST'), isFalse);
    });
  });
}

/// Bước giả lập adapter: trả HTTP status hoặc ném [DioExceptionType].
final class _AdapterStep {
  const _AdapterStep.status(this.statusCode) : failType = null;
  const _AdapterStep.fail(this.failType) : statusCode = null;

  final int? statusCode;
  final DioExceptionType? failType;
}

/// Adapter tuần tự cho safe-retry (timeout / status lẫn nhau).
final class _SequencedMixedAdapter implements HttpClientAdapter {
  _SequencedMixedAdapter(this.steps);

  final List<_AdapterStep> steps;
  var fetchCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final index = fetchCount.clamp(0, steps.length - 1);
    fetchCount++;
    final step = steps[index];
    final failType = step.failType;
    if (failType != null) {
      throw DioException(requestOptions: options, type: failType);
    }
    return ResponseBody.fromString(
      '{}',
      step.statusCode!,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
