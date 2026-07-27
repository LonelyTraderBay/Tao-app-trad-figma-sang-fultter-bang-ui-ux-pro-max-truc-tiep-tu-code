// Split from api_client_test.dart 2026-07-27 (400-line test file size gate,
// Future-Feature-Onboarding-Checklist). Covers errorMappingInterceptor,
// apiUserMessageForStatus, and mapBadResponseToApiFailure. See
// api_client_config_test.dart, api_client_auth_session_test.dart, and
// api_client_retry_test.dart for the other behavior groups split out of the
// same original file.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/data/offline_failure.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/core/network/api_error_mapper.dart';

void main() {
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
      const cases = <int, String>{
        400: 'không hợp lệ',
        401: 'Phiên',
        403: 'quyền',
        404: 'không còn tồn tại',
        409: 'Trạng thái',
        422: 'chưa hợp lệ',
        429: 'quá nhanh',
        500: 'gián đoạn',
      };
      for (final entry in cases.entries) {
        expect(
          apiUserMessageForStatus(entry.key),
          contains(entry.value),
          reason: 'status ${entry.key}',
        );
      }
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
