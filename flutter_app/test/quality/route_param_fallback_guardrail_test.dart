// Origin: e03df632 (2026-07-18) - feat(gd3-b): requireRouteParam + trang loi route vi + tach 832 route id theo nhom — dong Cum B GD3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// SEC-S45 (A-Plus GĐ3): cấm fallback THỰC THỂ demo cho path param trong
/// route builder (`?? 'p2p001'`, `?? 'sample'`...) — pattern này che giấu
/// lỗi điều hướng và render dữ liệu không phải của thực thể người dùng yêu
/// cầu trong luồng tài chính. Param bắt buộc dùng
/// `requireRouteParam(state, key)` (lib/app/router/route_error_page.dart).
///
/// Ngoại lệ CÓ CHỦ ĐÍCH (lớp b): default CHỢ/TÀI SẢN mặc định — pairId/
/// asset/assetId/eventId về 'btcusdt'/'USDT'/'btc' là landing hợp lý UX,
/// không phải thực thể riêng tư; các site này mang comment SEC-S45 tại chỗ.
void main() {
  test('route builder không dùng fallback thực thể demo cho path param', () {
    const allowedKeys = {'pairId', 'asset', 'assetId', 'eventId', 'year'};

    final pattern = RegExp(
      r"state\.pathParameters\['(\w+)'\]\s*\?\?\s*'([^']*)'",
      dotAll: true,
    );
    final violations = <String>[];
    final files =
        Directory(
          'lib/app/router/route_groups',
        ).listSync(recursive: true).whereType<File>().toList()..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );
    for (final file in files) {
      final path = file.path.replaceAll(r'\', '/');
      if (!path.endsWith('.dart')) continue;
      final source = file.readAsStringSync();
      for (final match in pattern.allMatches(source)) {
        final key = match.group(1)!;
        if (allowedKeys.contains(key)) continue;
        final line = source.substring(0, match.start).split('\n').length;
        violations.add("$path:$line ['$key'] ?? '${match.group(2)}'");
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Fallback thực thể demo mới cho path param — dùng '
          "requireRouteParam(state, 'key') để fail-loud thay vì render "
          'thực thể mẫu (SEC-S45): $violations',
    );
  });
}
