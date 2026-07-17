import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';

void main() {
  group('maskEmail', () {
    test('keeps the first local-part character and the full domain', () {
      expect(maskEmail('nguyenvana@email.com'), 'n***@email.com');
    });

    test('handles a 1-character local part', () {
      expect(maskEmail('a@email.com'), 'a***@email.com');
    });

    test('returns the input unchanged when there is no @', () {
      expect(maskEmail('not-an-email'), 'not-an-email');
    });

    test('returns the input unchanged when @ is the first character', () {
      expect(maskEmail('@email.com'), '@email.com');
    });
  });

  group('maskAccountNumber', () {
    test('returns empty string for empty input', () {
      expect(maskAccountNumber(''), '');
      expect(maskAccountNumber('   '), '');
    });

    test('masks entirely (***) when 4 characters or fewer', () {
      expect(maskAccountNumber('1'), '***');
      expect(maskAccountNumber('1234'), '***');
    });

    test('uses a 1-character prefix for 5-6 character values', () {
      expect(maskAccountNumber('12345'), '1...2345');
      expect(maskAccountNumber('123456'), '1...3456');
    });

    test('uses a 3-character prefix for 7+ character values', () {
      expect(maskAccountNumber('1234567'), '123...4567');
      expect(maskAccountNumber('0901234567'), '090...4567');
    });

    test('trims surrounding whitespace before masking', () {
      expect(maskAccountNumber('  0901234567  '), '090...4567');
    });
  });

  group('maskAddress', () {
    test('masks a typical wallet address with the default 6/4 split', () {
      expect(maskAddress('TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123'), 'TQnKxx...z123');
    });

    test('returns the input unchanged when too short to mask safely', () {
      // length <= head + tail (10 by default): masking would either
      // overlap or reveal the whole value anyway, so don't pretend to mask.
      expect(maskAddress('0123456789'), '0123456789');
      expect(maskAddress('short'), 'short');
      expect(maskAddress(''), '');
    });

    test('masks exactly at the boundary (length == head + tail + 1)', () {
      expect(maskAddress('01234567890'), '012345...7890');
    });

    test('supports custom head/tail lengths', () {
      expect(
        maskAddress('abcdefghijklmnopqrstuvwxyz', head: 10, tail: 4),
        'abcdefghij...wxyz',
      );
      expect(
        maskAddress('abcdefghijklmnopqrstuvwxyz0123456789', head: 20, tail: 10),
        'abcdefghijklmnopqrst...0123456789',
      );
    });

    test('trims surrounding whitespace before measuring/masking', () {
      expect(maskAddress('  TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123  '), 'TQnKxx...z123');
    });
  });
}
