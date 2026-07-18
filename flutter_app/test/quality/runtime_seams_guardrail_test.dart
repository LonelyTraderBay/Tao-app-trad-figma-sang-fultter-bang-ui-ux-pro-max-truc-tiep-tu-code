import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'architecture_baseline_guardrails_test_utils.dart';

// GĐ4-F1 — guardrail tầng runtime:
// (1) hai package persistence chỉ được import bên trong lib/core/storage/
//     (mọi nơi khác đi qua seam KeyValueStore/SecureStore);
// (2) main.dart phải giữ bootstrap hợp nhất: MỘT LocalLogErrorReporter cho
//     cả ba đường lỗi + override đủ ba seam runtime vào ProviderScope.
void main() {
  test('persistence packages chỉ được import trong lib/core/storage', () {
    final imports = sourceMatches(
      root: 'lib',
      pattern: RegExp(
        r"import 'package:(shared_preferences|flutter_secure_storage)",
      ),
      pathFilter: (path) =>
          !path.contains('/core/storage/') && !path.endsWith('lib/main.dart'),
    );
    expect(
      imports,
      isEmpty,
      reason:
          'Import shared_preferences/flutter_secure_storage ngoài '
          'lib/core/storage (main.dart là ngoại lệ bootstrap duy nhất): '
          '$imports. Dùng seam KeyValueStore/SecureStore thay vì package thô.',
    );
  });

  test('main.dart giữ bootstrap hợp nhất reporter + đủ ba seam runtime', () {
    final source = File('lib/main.dart').readAsStringSync();

    // Ba đường lỗi ngoài cây widget phải tồn tại đủ.
    expect(source, contains('FlutterError.onError'));
    expect(source, contains('PlatformDispatcher.instance.onError'));
    expect(source, contains('runZonedGuarded'));

    // MỘT instance LocalLogErrorReporter duy nhất, không còn Noop nào.
    expect(
      RegExp(r'LocalLogErrorReporter\(').allMatches(source).length,
      1,
      reason:
          'main.dart phải khởi tạo đúng MỘT LocalLogErrorReporter dùng chung '
          'cho mọi đường lỗi (hợp nhất GĐ4-F1).',
    );
    expect(
      source.contains('NoopErrorReporter('),
      isFalse,
      reason:
          'Bootstrap không được quay lại NoopErrorReporter — app thật phải '
          'ghi nhận lỗi qua LocalLogErrorReporter (ADR-008).',
    );

    // Cả ba seam runtime phải được bơm vào ProviderScope.
    expect(source, contains('errorReporterProvider.overrideWithValue'));
    expect(source, contains('keyValueStoreProvider.overrideWithValue'));
    expect(source, contains('secureStoreProvider.overrideWithValue'));
  });
}
