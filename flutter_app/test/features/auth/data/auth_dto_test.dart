import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:vit_trade_flutter/features/auth/data/dto/auth_dto_mappers.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/auth_session_dto.dart';
import 'package:vit_trade_flutter/features/auth/data/dto/login_request_dto.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';

/// GĐ4-F8 serialization pilot (ADR-010) — round-trip contract tests for the
/// PROVISIONAL auth DTOs. These pin the current JSON shape so any drift
/// (accidental key rename, dropped field, wrong DateTime encoding) is
/// caught before it reaches `AuthSessionController`'s SecureStore payload.
void main() {
  group('AuthSessionDto', () {
    final session = AuthSession(
      identifier: 'user@vittrade.vn',
      demo: true,
      issuedAt: DateTime.utc(2026, 7, 18, 10, 30, 45),
    );

    test(
      'round-trip entity -> dto -> json -> dto -> entity giữ nguyên từng trường',
      () {
        final dto = session.toDto();
        final json = dto.toJson();
        final decodedDto = AuthSessionDto.fromJson(json);
        final roundTripSession = decodedDto.toEntity();

        expect(roundTripSession.identifier, session.identifier);
        expect(roundTripSession.demo, session.demo);
        expect(roundTripSession.issuedAt, session.issuedAt);
      },
    );

    test('issuedAt được mã hóa dạng chuỗi ISO-8601', () {
      final json = session.toDto().toJson();

      expect(json['issuedAt'], isA<String>());
      expect(json['issuedAt'], session.issuedAt.toIso8601String());
      expect(DateTime.parse(json['issuedAt'] as String), session.issuedAt);
    });

    test('toJson dùng đúng khóa identifier/demo/issuedAt', () {
      final json = session.toDto().toJson();

      expect(
        json.keys,
        containsAll(<String>['identifier', 'demo', 'issuedAt']),
      );
      expect(json['identifier'], session.identifier);
      expect(json['demo'], session.demo);
    });

    test(
      'fromJson với JSON hợp lệ nhưng thiếu trường ném CheckedFromJsonException',
      () {
        final incompleteJson = <String, dynamic>{
          'identifier': 'user@vittrade.vn',
          // thiếu 'demo' và 'issuedAt' có chủ đích.
        };

        expect(
          () => AuthSessionDto.fromJson(incompleteJson),
          throwsA(isA<CheckedFromJsonException>()),
        );
      },
    );

    test('fromJson với sai kiểu trường ném CheckedFromJsonException', () {
      final wrongTypeJson = <String, dynamic>{
        'identifier': 'user@vittrade.vn',
        'demo': 'khong-phai-bool',
        'issuedAt': session.issuedAt.toIso8601String(),
      };

      expect(
        () => AuthSessionDto.fromJson(wrongTypeJson),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('jsonDecode với chuỗi không phải JSON hợp lệ ném FormatException', () {
      expect(() => jsonDecode('khong-phai-json'), throwsFormatException);
    });
  });

  group('LoginRequestDto', () {
    const request = LoginRequestDto(
      identifier: 'user@vittrade.vn',
      password: 's3cret-VI_DU_KHONG_THAT',
      demo: true,
    );

    test('round-trip dto -> json -> dto giữ nguyên từng trường', () {
      final json = request.toJson();
      final decoded = LoginRequestDto.fromJson(json);

      expect(decoded.identifier, request.identifier);
      expect(decoded.password, request.password);
      expect(decoded.demo, request.demo);
    });

    test('demo mặc định false khi không truyền', () {
      const defaultRequest = LoginRequestDto(
        identifier: 'user@vittrade.vn',
        password: 's3cret-VI_DU_KHONG_THAT',
      );

      expect(defaultRequest.demo, isFalse);
    });

    test(
      'fromJson với JSON hợp lệ nhưng thiếu trường bắt buộc ném CheckedFromJsonException',
      () {
        final incompleteJson = <String, dynamic>{
          'identifier': 'user@vittrade.vn',
        };

        expect(
          () => LoginRequestDto.fromJson(incompleteJson),
          throwsA(isA<CheckedFromJsonException>()),
        );
      },
    );
  });
}
