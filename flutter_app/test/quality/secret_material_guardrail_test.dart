import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// SEC-S41 (A-Plus GĐ2): chặn "secret material" trông-như-thật trong lib/.
///
/// Fixture/demo ĐƯỢC PHÉP dùng chuỗi dạng khóa API, nhưng phải tự khai là ví
/// dụ: chứa marker (VI_DU / EXAMPLE / demo) HOẶC gãy entropy (dấu `_`, `.`,
/// `...` cắt chuỗi alphanumeric dưới ngưỡng scanner). Baseline 2026-07-17:
/// 6 chuỗi vt_live_/sk_live_ 32-ký-tự trong mock_profile fixtures đã đổi sang
/// dạng `sk_live_VI_DU_KHONG_THAT_*` — guardrail này giữ trạng thái đó.
///
/// Đây là tuyến phòng thủ LOCAL (chạy trong full suite lẫn CI); tuyến CI bổ
/// sung là job gitleaks (.github/workflows/flutter-ci.yml) + .gitleaks.toml
/// allowlist marker VI_DU_KHONG_THAT.
void main() {
  test('lib/ khong chua secret material trong-nhu-that', () {
    // Mỗi pattern nhắm một họ khóa thật; chuỗi ví dụ có marker hoặc bị `_`
    // cắt ngắn run alphanumeric sẽ không match.
    final patterns = <String, RegExp>{
      // Khóa kiểu Stripe/VitTrade: prefix + >=20 ký tự alnum LIỀN MẠCH.
      'api-key-entropy': RegExp(
        r'''['"](?:vt|sk|pk|rk)_(?:live|test|prod)_[0-9A-Za-z]{20,}['"]''',
      ),
      'aws-access-key': RegExp(r'AKIA[0-9A-Z]{16}'),
      'github-token': RegExp(r'gh[pousr]_[0-9A-Za-z]{36,}'),
      'slack-token': RegExp(r'xox[baprs]-[0-9A-Za-z-]{10,}'),
      'private-key-block': RegExp(
        r'-----BEGIN (?:RSA |EC |OPENSSH |PGP )?PRIVATE KEY',
      ),
      'google-api-key': RegExp(r'AIza[0-9A-Za-z_-]{35}'),
      'jwt-literal': RegExp(r'eyJ[0-9A-Za-z_-]{20,}\.eyJ'),
    };

    final violations = <String>[];
    final files =
        Directory('lib').listSync(recursive: true).whereType<File>().toList()
          ..sort(
            (a, b) => a.path
                .replaceAll(r'\', '/')
                .compareTo(b.path.replaceAll(r'\', '/')),
          );
    for (final file in files) {
      final path = file.path.replaceAll(r'\', '/');
      if (!path.endsWith('.dart')) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        for (final entry in patterns.entries) {
          if (!entry.value.hasMatch(line)) continue;
          violations.add('$path:${i + 1} [${entry.key}] ${line.trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Chuỗi giống secret thật trong lib/ — đổi sang dạng ví dụ tự khai '
          '(vd. sk_live_VI_DU_KHONG_THAT_...) để secret scanner và người đọc '
          'không thể nhầm là khóa rò rỉ: $violations',
    );
  });
}
