// Origin: bc10382c (2026-07-17) - feat(i18n+format): chinh sach vi-VN-only + locale vi + facade VitFormat — dong Cum 5
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// FMT-1 (A-Plus GĐ2, DEC-i18n phương án (a)): mọi call site format tiền tệ /
/// nhóm nghìn dùng chung phải đi qua facade `VitFormat`
/// (lib/shared/utils/vit_format.dart) — import thẳng 2 file formatter nguồn
/// bị cấm ngoài facade. Bài học VitFormat copy drift 440dcb06: dedup formatter
/// từng đổi copy tiền âm thầm; một facade duy nhất giữ format đổi được ở MỘT
/// nơi. Helper cục bộ theo module (vd. dca_currency_formatters.dart) không
/// thuộc phạm vi — guardrail chỉ khóa 2 file nguồn dùng chung.
void main() {
  test('formatter nguồn chỉ được import qua facade VitFormat', () {
    const bannedImports = [
      'package:vit_trade_flutter/shared/utils/currency_formatters.dart',
      'package:vit_trade_flutter/core/utils/number_formatters.dart',
    ];
    const facadePath = 'lib/shared/utils/vit_format.dart';

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
      if (path == facadePath) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('import ')) continue;
        for (final banned in bannedImports) {
          if (line.contains(banned)) {
            violations.add('$path:${i + 1} -> $banned');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Import thẳng formatter nguồn ngoài facade — dùng VitFormat '
          '(usd/count/thousands/...) để format tiền tệ đổi được ở một nơi '
          'duy nhất (drift 440dcb06): $violations',
    );
  });
}
