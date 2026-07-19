// Origin: 15eaea03 (2026-07-18) - feat(gd3-f): api_client interceptors + dartdoc 2066 symbol + coverage ratchet 92 — A-PLUS GATE PASS GD3
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// DOC-D7 (A-Plus GĐ3): mọi symbol public trong vùng CONTRACT (lib/shared +
/// lib/features/**/domain) phải có dartdoc `///` ngay phía trên — đây là API
/// mà mọi feature/backend integration dựa vào.
///
/// DRIFT so manifest (có chủ đích): enforce bằng guardrail test thay vì bật
/// `public_member_api_docs` per-directory — nested analysis_options phá strict
/// include + plugin custom_lint; guardrail test là văn hóa enforcement sẵn có
/// của repo. Quét khai báo TOP-LEVEL public (class/enum/extension/typedef/
/// mixin/function/const) — member bên trong class không bắt (mức khởi điểm
/// hợp lý, siết dần nếu cần).
void main() {
  test('lib/shared + domain: symbol public top-level có dartdoc', () {
    final declaration = RegExp(
      r'^(?:final |abstract |sealed |base |interface )*'
      r'(class|enum|extension|typedef|mixin)\s+([A-Za-z]\w*)|'
      r'^(?:Future<[^>]+>|Stream<[^>]+>|[A-Z]\w*(?:<[^>]*>)?|void|bool|int|'
      r'double|num|String)\s+([a-z]\w*)\s*\(',
    );

    final roots = [Directory('lib/shared'), Directory('lib/features')];
    final violations = <String>[];

    for (final root in roots) {
      final files = root.listSync(recursive: true).whereType<File>().toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );
      for (final file in files) {
        final path = file.path.replaceAll(r'\', '/');
        if (!path.endsWith('.dart')) continue;
        if (path.startsWith('lib/features') && !path.contains('/domain/')) {
          continue;
        }
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          // Chỉ xét khai báo cột 0 (top-level).
          if (line.isEmpty || line.startsWith(' ') || line.startsWith('\t')) {
            continue;
          }
          final match = declaration.firstMatch(line);
          if (match == null) continue;
          final name = match.group(2) ?? match.group(3)!;
          if (name.startsWith('_')) continue;

          // Ngược lên bỏ qua annotation/comment thường để tìm `///`.
          var j = i - 1;
          while (j >= 0 &&
              (lines[j].trimLeft().startsWith('@') ||
                  lines[j].trim().isEmpty)) {
            j--;
          }
          final hasDoc = j >= 0 && lines[j].trimLeft().startsWith('///');
          if (!hasDoc) {
            violations.add('$path:${i + 1} $name');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Symbol public top-level trong vùng contract thiếu dartdoc /// '
          '(DOC-D7) — thêm mô tả NGẮN đúng vai trò ngay phía trên khai báo '
          '(${violations.length} chỗ): '
          '${violations.take(40).join('; ')}'
          '${violations.length > 40 ? '; ...' : ''}',
    );
  });
}
